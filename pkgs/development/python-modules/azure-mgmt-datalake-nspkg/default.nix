{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-mgmt-nspkg,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-datalake-nspkg";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "deb192ba422f8b3ec272ce4e88736796f216f28ea5b03f28331d784b7a3f4880";
  };

  build-system = [ setuptools ];

  dependencies = [ azure-mgmt-nspkg ];

  # has no tests
  doCheck = false;

  meta = {
    description = "This is the Microsoft Azure Data Lake Management namespace package";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
