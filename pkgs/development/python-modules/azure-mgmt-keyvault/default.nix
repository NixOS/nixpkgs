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
  version = "9.2.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "37ecd44c49ceca7d7c9431e59148febd15d7fec261651ed72ddd58755e7450b0";
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
    maintainers = with maintainers; [ jonringer maxwilson ];
  };
}
