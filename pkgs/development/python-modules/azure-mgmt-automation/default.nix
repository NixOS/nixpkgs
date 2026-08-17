{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  msrest,
  azure-common,
  azure-mgmt-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-automation";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_automation";
    inherit (finalAttrs) version;
    hash = "sha256-A/NYbg/gllws7cp5plM4CHKuYnwm6lNlpVuqTq1aeO8=";
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

  meta = {
    description = "This is the Microsoft Azure Automation Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/automation/azure-mgmt-automation";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-automation_${finalAttrs.version}/sdk/automation/azure-mgmt-automation/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wfdewith ];
  };
})
