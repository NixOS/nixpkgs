{
  lib,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  msrest,
  typing-extensions,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-containerservice";
  version = "41.8.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_containerservice";
    inherit version;
    hash = "sha256-h/3A/MUXhTs4ISfKi7HHRvah06xb9t5Y5gyGdU6BDVg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrest
    azure-mgmt-core
    typing-extensions
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.containerservice" ];

  meta = {
    description = "This is the Microsoft Azure Container Service Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/containerservice/azure-mgmt-containerservice";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-containerservice_${version}/sdk/containerservice/azure-mgmt-containerservice/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
