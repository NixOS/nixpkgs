{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
, azure-mgmt-core
}:

buildPythonPackage rec {
  pname = "azure-mgmt-keyvault";
  version = "7.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "128c1424373aabab5ffcfa74a3ee73cf8bda0a9259229ce2c1d09a8bc9f7370a";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
    azure-mgmt-nspkg
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Key Vault Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer mwilsoninsight ];
  };
}
