## 22 Sep 2015 - Getting and Cleaning data Project R Script
## The data is based on the  project from "Human Activity Recognition Using Smartphones Data Set"
## Abstract: Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors
## The following script will merge the data from various .txt files abtained from the location https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
## expected output is a clean data which will be used for further analysis
## this script needs package "reshape2" installed 

## check if the pakage is installed if not the program will install the package
if (!("reshape2" %in% rownames(installed.packages())) ) {
  print("Required package was not installed please install pakage reshape2")
} else 
  
{
  ## set library
  library(reshape2)

## read all txt files and label them as required

## finding all activities from file activity_lables.txt and label the dataset
act_lables <- read.table("./activity_labels.txt",col.names=c("activity_id","activity_name"))

## read features.txt
feat <- read.table("features.txt")
feat_name <- feat[,2]

## read test data and assign label 
testdata <- read.table("./test/X_test.txt")
colnames(testdata) <- feat_name

## Read training data and assign label
traindata <- read.table("./train/X_train.txt")
colnames(traindata) <- feat_name

## read test ids and assign lable
test_sub_id <- read.table("./test/subject_test.txt")
colnames(test_sub_id) <- "subject_id"

## Read the activity id's of the test data and label the the dataframe's columns
test_act_id <- read.table("./test/y_test.txt")
colnames(test_act_id) <- "activity_id"


## read train ids and assign label
train_sub_id <- read.table("./train/subject_train.txt")
colnames(train_sub_id) <- "subject_id"


## read act id of activity data and label the dataframe col
train_act_id <- read.table("./train/y_train.txt")
colnames(train_act_id) <- "activity_id"

## merging test subject id and test Ids and testdata into one data frame
test_data <- cbind(test_sub_id, test_act_id, testdata)


## merging train subject id and test Ids and traindata into one data frame
train_data <- cbind(train_sub_id, train_act_id, traindata)


## combine test and traion data in one dataframe
alldata <- rbind(train_data, test_data)


## keeping mean and std values
meancolids <- grep("mean",names(alldata),ignore.case=TRUE)
meancolnms <- names(alldata)[]
stdcolids <- grep("std",names(alldata),ignore.case=TRUE)
stdcolnms <- names(alldata)[stdcolids]
meanstddata <-alldata[,c("subject_id","activity_id",meancolnms,stdcolnms)]

##Merge the activities dataset and mean/std values dataset to one dataset with descriptive activity names
descnames <- merge(act_lables,meanstddata,by.x="activity_id",by.y="activity_id",all=TRUE)

##Melt the dataset with the descriptive activity names 
datamelt <- melt(descnames,id=c("activity_id","activity_name","subject_id"))

##Cast the melted dataset as per average of all variable and for all activities and subject
mean_data <- dcast(datamelt,activity_id + activity_name + subject_id ~ variable,mean)

## Create a new clean data
write.table(mean_data,"./clean_tidy_data.txt")

}
