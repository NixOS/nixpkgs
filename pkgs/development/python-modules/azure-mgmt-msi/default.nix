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

  postInstall = lib.optionalString isPy3k ''
    rm -f $out/${python.sitePackages}/azure/__init__.py
    rm -f $out/${python.sitePackages}/azure/mgmt/__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure MSI Management Client Library";
    homepage = https://github.com/Azure/azure-sdk-for-python/tree/master/azure-mgmt-msi;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
