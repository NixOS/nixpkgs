{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrestazure,
  azure-common,
  azure-mgmt-datalake-nspkg,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-datalake-analytics";
  version = "0.6.0";
  format = "setuptools";

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

  pythonNamespaces = [ "azure.mgmt.datalake" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Data Lake Analytics Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
