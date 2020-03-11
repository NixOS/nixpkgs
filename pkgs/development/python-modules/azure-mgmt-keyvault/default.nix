{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-keyvault";
  version = "2.1.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0ga6lzqlinfxlzx1g35a5sv5chjx4im0m4b8i33hqrhmdv9m7ypg";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # this is still need when overriding to prevoius versions
  # E.g. azure-cli
  postInstall = lib.optionalString isPy3k ''
    rm -f $out/${python.sitePackages}/azure/{,mgmt/}__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Key Vault Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer mwilsoninsight ];
  };
}
