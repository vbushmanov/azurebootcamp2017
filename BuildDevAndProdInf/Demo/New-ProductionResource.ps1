# Resource AGENDA
# - Create network, include \front subnet \back subnet
# - Create network security rules for front subnet
# - Create VM - Role:  WEB server

#Global variables
$subscription = Get-AzureRmSubscription | Out-GridView -PassThru -Title "Select subscription"
$resourceGroupName = "gabprod"
$location = "eastus"

#########################################
# Create network
#########################################
# Network variables
$NetworkVariables =  @{
             vnetName = "$resourceGroupName-vnet-01";
             vnetaddressPrefixes = "172.27.0.0/16";
             frontSubnetaddressName = "$resourceGroupName-front-subnet-01";
             frontSubnetaddressPrefix = "172.27.10.0/24";
             backSubnetaddressName = "$resourceGroupName-back-subnet-01";
             backSubnetaddressPrefix = "172.27.20.0/24";
             resourceGroupName = "$resourceGroupName";
             location = "$location";   
}
.\New-ResourceFromTemplate.ps1 -subscriptionId $subscription.subscriptionId `
                               -resourceGroupName $NetworkVariables.resourceGroupName `
                               -resourceGroupLocation $NetworkVariables.location `
                               -templateFilePath .\templates\Network.json `
                               -parametersObject $NetworkVariables `
                               -deploymentName "Virtual network"

#########################################
# Create network security group
# depend on: "Create network"
#
#########################################
#network security group variables
$frontSubnetNsg =  @{
             addressPrefix = $NetworkVariables.vnetaddressPrefixes;
             networkSecurityGroupName = $NetworkVariables.frontSubnetaddressName;
             virtualNetworkName = $NetworkVariables.vnetName;
             subnetName = $NetworkVariables.frontSubnetaddressName;
             subnetPrefix = $NetworkVariables.frontSubnetaddressPrefix;
      
}
.\New-ResourceFromTemplate.ps1 -subscriptionId $subscription.subscriptionId `
                               -resourceGroupName $resourceGroupName `
                               -resourceGroupLocation $location `
                               -templateFilePath .\templates\NSG.json `
                               -parametersObject $frontSubnetNsg `
                               -deploymentName "Network Security Group"

#########################################
# Create VM - Role: web server
# Description : front end server
# depend on: "Create network"
#            
#########################################
$vmName = "$resourceGroupName-web"
$WebServerVariables =  @{
             vmName = "$vmName-01";
             dnsLabelPrefix = "$vmName-server"
             nicName = "$vmName-01-nic-01";
             addressPrefix = $NetworkVariables.frontSubnetaddressPrefix;
             publicIPAddressName = "$vmName-01-pip-01";
             storageAccountName = $resourceGroupName + 'stor01';
             adminUsername = "gabopsadmin";
             adminPassword = "HjuhGteYYU123";
             subnetName = $NetworkVariables.frontSubnetaddressName;
             virtualNetworkName = $NetworkVariables.vnetName;
             subnetaddressPrefix = $NetworkVariables.frontSubnetaddressPrefix;
             vmSize = "Standard_A2";
             windowsOSVersion = "2012-Datacenter";
             resourceGroupName = "$resourceGroupName";
             
}
.\New-ResourceFromTemplate.ps1 -subscriptionId $subscription.subscriptionId `
                               -resourceGroupName $WebServerVariables.resourceGroupName `
                               -resourceGroupLocation $location `
                               -templateFilePath .\templates\WindowsVM.json `
                               -parametersObject $WebServerVariables `
                               -deploymentName "Virtual network"


$vmName = "$resourceGroupName-web"
$WebServerVariables =  @{
             vmName = "$vmName-01";
             dnsLabelPrefix = "$vmName-server"
             nicName = "$vmName-01-nic-01";
             addressPrefix = $NetworkVariables.frontSubnetaddressPrefix;
             publicIPAddressName = "$vmName-01-pip-01";
             storageAccountName = $resourceGroupName + 'stor01';
             adminUsername = "gabopsadmin";
             adminPassword = "HjuhGteYYU123";
             subnetName = $NetworkVariables.frontSubnetaddressName;
             virtualNetworkName = $NetworkVariables.vnetName;
             subnetaddressPrefix = $NetworkVariables.frontSubnetaddressPrefix;
             vmSize = "Standard_A2";
             windowsOSVersion = "2012-Datacenter";
             resourceGroupName = "$resourceGroupName";
             
}
.\New-ResourceFromTemplate.ps1 -subscriptionId $subscription.subscriptionId `
                               -resourceGroupName $WebServerVariables.resourceGroupName `
                               -resourceGroupLocation $location `
                               -templateFilePath .\templates\WindowsVM.json `
                               -parametersObject $WebServerVariables `
                               -deploymentName "Virtual network"