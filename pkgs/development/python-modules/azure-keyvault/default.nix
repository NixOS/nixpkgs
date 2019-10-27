{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-nspkg
, msrest
, msrestazure
, cryptography
}:

buildPythonPackage rec {
  pname = "azure-keyvault";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "37a8e5f376eb5a304fcd066d414b5d93b987e68f9212b0c41efa37d429aadd49";
  };

  propagatedBuildInputs = [
    azure-common
    azure-nspkg
    msrest
    msrestazure
    cryptography
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Key Vault Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
