{ lib
, buildPythonPackage
, fetchPypi
, azure-mgmt-common
, azure-mgmt-core
, isPy3k
}:

buildPythonPackage rec {
  version = "19.1.0";
  pname = "azure-mgmt-storage";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-Seoi8A4JZaNVCvNKQcGh06SBaQ9lAMeOhUCIAvVtdBY=";
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
