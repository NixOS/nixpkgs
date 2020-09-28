{ lib
, buildPythonPackage
, fetchPypi
, python
, azure-mgmt-common
, azure-mgmt-core
, isPy3k
}:

buildPythonPackage rec {
  version = "16.0.0";
  pname = "azure-mgmt-storage";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "2f9d714d9722b1ef4bac6563676612e6e795c4e90f6f3cd323616fdadb0a99e5";
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
    maintainers = with maintainers; [ jonringer olcai mwilsoninsight ];
  };
}
