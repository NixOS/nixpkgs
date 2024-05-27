{
  lib,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-keyvault-secrets";
  version = "4.8.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VjbAodiiDjxXmcs8z/1Ovz8NGst8rpUmhhgzr4sP6BQ=";
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

  meta = with lib; {
    description = "Microsoft Azure Key Vault Secrets Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/keyvault/azure-keyvault-secrets";
    changelog = "https://github.com/Azure/azure-sdk-for-python/tree/azure-keyvault-secrets_${version}/sdk/keyvault/azure-keyvault-secrets";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
