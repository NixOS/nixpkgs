{
  lib,
  azure-common,
  azure-core,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-keyvault-keys";
  version = "4.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CGMtzW7OKGVyBOmiVq1kNp/isOOF7UM0n5MvAH2J93Q=";
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

  meta = with lib; {
    description = "Microsoft Azure Key Vault Keys Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/keyvault/azure-keyvault-keys";
    changelog = "https://github.com/Azure/azure-sdk-for-python/tree/azure-keyvault-keys_${version}/sdk/keyvault/azure-keyvault-keys";
    license = licenses.mit;
    maintainers = [ ];
  };
}
