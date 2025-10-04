{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-datafactory";
  version = "9.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_mgmt_datafactory";
    inherit version;
    hash = "sha256-UTLpwkxEGsIl8qYCJZJLqlUHnKge/325mnDWYdZLsNc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.datafactory" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Data Factory Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/tree/azure-mgmt-datafactory_${version}/sdk/datafactory/azure-mgmt-datafactory";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
