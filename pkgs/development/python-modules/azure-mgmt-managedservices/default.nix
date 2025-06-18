{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  msrest,
  msrestazure,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-managedservices";
  version = "6.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7AyzhYvPjt9e7g7d7oFWBCTrhDUuDfCC3clOuZut/V4=";
    extension = "zip";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.managedservices"
  ];

  meta = with lib; {
    description = "Microsoft Azure Managed Services Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/managedservices/azure-mgmt-managedservices";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-managedservices_${version}/sdk/managedservices/azure-mgmt-managedservices/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
