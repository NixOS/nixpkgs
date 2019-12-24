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
  pname = "azure-mgmt-datalake-analytics";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0d64c4689a67d6138eb9ffbaff2eda2bace7d30b846401673183dcb42714de8f";
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
    description = "This is the Microsoft Azure Data Lake Analytics Management Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-datalake-analytics;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
