{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-mgmt-nspkg,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-datalake-nspkg";
  version = "3.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-3rGSukIviz7Ccs5OiHNnlvIW8o6lsD8oMx14S3o/SIA=";
  };

  propagatedBuildInputs = [ azure-mgmt-nspkg ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Data Lake Management namespace package";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
