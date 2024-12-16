{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  msrest,
  azure-common,
  azure-mgmt-core,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-automation";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-pJ0tQT/vVwEMs2Fh5bwFZgG418bQW9PLBaE1Eu8pHh4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrest
    azure-common
    azure-mgmt-core
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.automation" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Automation Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/automation/azure-mgmt-automation";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-automation_${version}/sdk/automation/azure-mgmt-automation/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ wfdewith ];
  };
}
