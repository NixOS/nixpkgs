{
  lib,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  msrest,
  typing-extensions,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-containerservice";
  version = "40.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "azure_mgmt_containerservice";
    inherit version;
    hash = "sha256-bFKgzV1VUg7wKOqQtyvY0TKPgNDOaXQ072HFBoYmr28=";
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

  meta = with lib; {
    description = "This is the Microsoft Azure Container Service Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/containerservice/azure-mgmt-containerservice";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-containerservice_${version}/sdk/containerservice/azure-mgmt-containerservice/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
