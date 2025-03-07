{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  msrest,
  azure-common,
  azure-mgmt-core,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-msi";
  version = "7.0.0";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-ctRsmmJ4PsTqthm+nRt4/+u9qhZNQG/TA/FjA/NyVrI=";
  };

  propagatedBuildInputs = [
    msrest
    azure-common
    azure-mgmt-core
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.msi" ];

  meta = with lib; {
    description = "This is the Microsoft Azure MSI Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/resources/azure-mgmt-msi";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
