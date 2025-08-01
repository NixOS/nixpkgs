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
  pname = "azure-mgmt-sqlvirtualmachine";
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-talCNRKnsShErAFDZqHVPIEBehTzlna+7fAEpTKqKq0=";
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

  meta = with lib; {
    description = "Microsoft Azure SQL Virtual Machine Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/sql/azure-mgmt-sqlvirtualmachine";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-sqlvirtualmachine_${version}/sdk/sql/azure-mgmt-sqlvirtualmachine/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
