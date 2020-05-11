library(gganimate)
library(hrbrthemes)
library(tidyverse)
library(haven)
library(janitor)
library(MplusAutomation)
library(rhdf5)
library(here)
library(kableExtra)
library(gtsummary)
library(semPlot)




###Read in data 

lsay_data <- read_spss(here("data", "LSAY_HW6.sav")) %>% 
  select(-starts_with("AB"),
         ends_with("IMP"),
         -contains("BIO"),
         -contains("PHY"),
         -contains("MTH"),
         FATHED, MOTHED) %>% 
  clean_names() %>% 
  rename( sci_07 = asciimp ,
          sci_08 = csciimp ,
          sci_09 = esciimp ,
          sci_10 = gsciimp ,
          sci_11 = isciimp ,
          sci_12 = ksciimp )

lsay_data[lsay_data == 9999.00] <- NA

write_csv(lsay_data, here("data", "lsay_hw6_data.csv"))

###
m1_growth  <- mplusObject(
  TITLE = "m1 growth model fixed time scores - hw 6", 
  VARIABLE = 
    "usevar =
    sci_07-sci_12; ", 
  
  ANALYSIS = 
    "estimator = ML" ,
  
  MODEL = 
    "i s | sci_07@0 sci_08@1 sci_09@2 sci_10@3 sci_11@4 sci_12@5; " ,
  
  OUTPUT = "sampstat standardized;",
  
  PLOT = "type=plot3;
          series = sci_07-sci_12(*)",
  
  usevariables = colnames(lsay_hw6_data),   
  rdata = lsay_hw6_data)                    

m1_growth_fit <- mplusModeler(m1_growth,
                              dataout=here("mplus_files", "hw6.dat"),       
                              modelout=here("mplus_files", "m1_growth_hw6.inp"),
                              check=TRUE, run = TRUE, hashfilename = FALSE)


source(here("mplus.R.txt"))
mplus.view.plots(here("mplus_files", "m1_growth_hw6.gh5"))




