{
  lib,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-keyvault-secrets";
  version = "4.11.3";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_keyvault_secrets";
    inherit version;
    hash = "sha256-GTujz5kSrndvsbpA0UeqPL/PXNpeDi4174++THjbEhc=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    azure-core
    isodate
    typing-extensions
  ];

  pythonNamespaces = [ "azure.keyvault" ];

  # Tests require checkout from mono-repo
  doCheck = false;

  meta = {
    description = "Microsoft Azure Key Vault Secrets Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/keyvault/azure-keyvault-secrets";
    changelog = "https://github.com/Azure/azure-sdk-for-python/tree/azure-keyvault-secrets_${version}/sdk/keyvault/azure-keyvault-secrets";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
