{
  lib,
  azure-common,
  azure-core,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  isodate,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-keyvault-keys";
  version = "4.11.1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_keyvault_keys";
    inherit version;
    hash = "sha256-kMqjp7LI9rU8JH7BFc8cHa1/EHzDqp81r/SDi7zn5WI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-core
    cryptography
    isodate
    typing-extensions
  ];

  pythonNamespaces = [ "azure.keyvault" ];

  # Tests require relative paths to utilities in the mono-repo
  doCheck = false;

  pythonImportsCheck = [
    "azure"
    "azure.core"
    "azure.common"
    "azure.keyvault"
    "azure.keyvault.keys"
  ];

  meta = {
    description = "Microsoft Azure Key Vault Keys Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/keyvault/azure-keyvault-keys";
    changelog = "https://github.com/Azure/azure-sdk-for-python/tree/azure-keyvault-keys_${version}/sdk/keyvault/azure-keyvault-keys";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
