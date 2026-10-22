{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  azure-keyvault-certificates,
  azure-keyvault-keys,
  azure-keyvault-secrets,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-keyvault";
  version = "4.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-cxrdEIo+KatP1QGjxHclbChsNNCZazg/tqOUVGKTN2E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-keyvault-certificates
    azure-keyvault-keys
    azure-keyvault-secrets
  ];

  # this is just a meta package, which contains keys and secrets packages
  doCheck = false;
  doBuild = false;

  pythonImportsCheck = [
    "azure.keyvault.keys"
    "azure.keyvault.secrets"
  ];

  meta = {
    description = "This is the Microsoft Azure Key Vault Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
