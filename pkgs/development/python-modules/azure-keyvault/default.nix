{ lib
, buildPythonPackage
, python
, isPy3k
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

  postInstall = lib.optionalString isPy3k ''
    rm $out/${python.sitePackages}/azure/__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Key Vault Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/key-vault?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
