{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  msrest,
  azure-common,
}:

buildPythonPackage (finalAttrs: {
  version = "0.1.1";
  pyproject = true;

  __structuredAttrs = true;
  pname = "azure-loganalytics";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-aP+5oiBuBrlnIQCo5jUcwE91u4GGfzDUFsaLVdYk15M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrest
    azure-common
  ];

  pythonNamespaces = [ "azure" ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.loganalytics" ];

  meta = {
    description = "This is the Microsoft Azure Log Analytics Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      maxwilson
    ];
  };
})
