{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-mgmt-nspkg,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-datalake-nspkg";
  version = "3.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-3rGSukIviz7Ccs5OiHNnlvIW8o6lsD8oMx14S3o/SIA=";
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
})
