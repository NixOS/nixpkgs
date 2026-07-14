{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrest,
  msrestazure,
  azure-common,
  azure-mgmt-core,
  azure-mgmt-nspkg,
  isPy3k,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-sql";
  version = "3.0.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-EpBCzAESJeJ67m7yaX1YX6VyLl0a6wA4r2rSRRooVFc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ]
  ++ lib.optionals (!isPy3k) [ azure-mgmt-nspkg ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.sql" ];

  meta = {
    description = "This is the Microsoft Azure SQL Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
})
