{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  msrestazure,
  azure-common,
  azure-mgmt-datalake-nspkg,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-datalake-analytics";
  version = "0.6.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-DWTEaJpn1hOOuf+6/y7aK6zn0wuEZAFnMYPctCcU3o8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrestazure
    azure-common
    azure-mgmt-datalake-nspkg
  ];

  pythonNamespaces = [ "azure.mgmt.datalake" ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.datalake.analytics" ];

  meta = {
    description = "This is the Microsoft Azure Data Lake Analytics Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
})
