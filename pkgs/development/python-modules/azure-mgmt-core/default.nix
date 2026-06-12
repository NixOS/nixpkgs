{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  azure-core,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-core";
  version = "1.6.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "azure_mgmt_core";
    inherit (finalAttrs) version;
    extension = "tar.gz";
    hash = "sha256-smIyr4V7Ah5h2BPZ9K5TBGUlXLELPd6UWtN0P3pY55w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    typing-extensions
  ];

  pythonNamespaces = "azure.mgmt";

  # not included
  doCheck = false;

  pythonImportsCheck = [
    "azure.mgmt.core"
    "azure.core"
  ];

  meta = {
    description = "Microsoft Azure Management Core Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
