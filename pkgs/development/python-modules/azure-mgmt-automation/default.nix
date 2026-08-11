{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  msrest,
  azure-core,
  azure-mgmt-core,
  isodate,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-automation";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_automation";
    inherit (finalAttrs) version;
    hash = "sha256-nRVIwul58bj8PtUXc/yEo0BkVSAzU+f3v19A5YEQmRY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.automation" ];

  meta = {
    description = "This is the Microsoft Azure Automation Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/automation/azure-mgmt-automation";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-automation_${finalAttrs.version}/sdk/automation/azure-mgmt-automation/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wfdewith ];
  };
})
