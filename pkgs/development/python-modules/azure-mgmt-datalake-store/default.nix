{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
, msrestazure
, azure-common
, azure-mgmt-datalake-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-datalake-store";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "9376d35495661d19f8acc5604f67b0bc59493b1835bbc480f9a1952f90017a4c";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-datalake-nspkg
  ];

  postInstall = lib.optionalString isPy3k ''
    rm $out/${python.sitePackages}/azure/__init__.py
    rm $out/${python.sitePackages}/azure/mgmt/__init__.py
    rm $out/${python.sitePackages}/azure/mgmt/datalake/__init__.py
  '';

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Data Lake Store Management Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-datalake-store;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer mwilsoninsight ];
  };
}
