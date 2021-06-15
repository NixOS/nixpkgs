{ lib
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
, azure-mgmt-core
, isPy3k
}:

buildPythonPackage rec {
  version = "18.0.0";
  pname = "azure-mgmt-storage";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "d17beb34273797fa89863632ff0e1eb9b6a55198abb8c7f05d84980762e5f71f";
  };

  propagatedBuildInputs = [
    azure-mgmt-common
    azure-mgmt-core
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.mgmt.storage" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Storage Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer olcai maxwilson ];
  };
}
