{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  azure-nspkg,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-storage-nspkg";
  version = "3.1.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-bzu+hlLV9UJ2fYQz5/lrjff1GHdAVax8ku18qF9lOBE=";
  };

  build-system = [ setuptools ];

  dependencies = [ azure-nspkg ];

  # has no tests
  doCheck = false;

  meta = {
    description = "Client library for Microsoft Azure Storage services owning the azure.storage namespace, user should not use this directly";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cmcdragonkai ];
  };
})
