{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  msrest,
  msrestazure,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-sqlvirtualmachine";
  version = "1.0.0b5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZFgJflgynRSxo+B+Vso4eX1JheWlDQjfJ9QmupXypMc=";
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
    "azure.mgmt.sqlvirtualmachine"
  ];

  meta = {
    description = "Microsoft Azure SQL Virtual Machine Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/sql/azure-mgmt-sqlvirtualmachine";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-sqlvirtualmachine_${version}/sdk/sql/azure-mgmt-sqlvirtualmachine/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
