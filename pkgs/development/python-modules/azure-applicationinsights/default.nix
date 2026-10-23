{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  msrest,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-applicationinsights";
  version = "0.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-qIRbgDZbfyALrR9xqA0NMfO+wB7f1GfftsE+or1xupY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    msrest
  ];

  # has no tests
  doCheck = false;

  meta = {
    description = "This is the Microsoft Azure Application Insights Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
})
