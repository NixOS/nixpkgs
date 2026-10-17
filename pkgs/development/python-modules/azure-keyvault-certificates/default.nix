{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  azure-core,
  isodate,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-keyvault-certificates";
  version = "4.11.3";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_keyvault_certificates";
    inherit version;
    hash = "sha256-vob3IlSpyOuRgiCl9io4hWie1lJnQ7ZLqz3JTnYyf7A=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    azure-common
    azure-core
    isodate
    typing-extensions
  ];

  pythonNamespaces = [ "azure.keyvault" ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.keyvault.certificates" ];

  meta = {
    description = "Microsoft Azure Key Vault Certificates Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/keyvault/azure-keyvault-certificates";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-keyvault-certificates_${version}/sdk/keyvault/azure-keyvault-certificates/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
