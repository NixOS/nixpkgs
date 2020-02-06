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
  pname = "azure-mgmt-msi";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0n4gbwk843z66hhpcp1kcrnwqkzygbbc2ma01r9asgfv4nmklvyl";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # still needed when overriding to previous versions
  # E.g. azure-cli
  postInstall = lib.optionalString isPy3k ''
    rm -f $out/${python.sitePackages}/azure/{,mgmt/}__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure MSI Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
