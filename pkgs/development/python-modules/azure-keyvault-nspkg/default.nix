{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,

  # pythonPackages
  azure-nspkg,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-keyvault-nspkg";
  version = "1.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-rGi4iqucbK9Uoj2iodHHGNdSC65a3/BN0KdDIoJptkE=";
  };

  build-system = [ setuptools ];

  dependencies = [ azure-nspkg ];

  # Just a namespace package, no tests exist:
  #   https://github.com/Azure/azure-sdk-for-python/blob/master/sdk/keyvault/tests.yml
  doCheck = false;

  meta = {
    description = "Microsoft Azure Key Vault Namespace Package [Internal]";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
