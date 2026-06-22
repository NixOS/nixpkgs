{
  lib,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-cosmos";
  version = "4.16.1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_cosmos";
    inherit version;
    hash = "sha256-+hXRNwK0cCZaZ+LdnAeUAh5rd2hW2sbCI9ysxNjh2NE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    typing-extensions
  ];

  pythonNamespaces = [ "azure" ];

  # Requires an active Azure Cosmos service
  doCheck = false;

  pythonImportsCheck = [ "azure.cosmos" ];

  meta = {
    description = "Azure Cosmos DB API";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/cosmos/azure-cosmos";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-cosmos_${version}/sdk/cosmos/azure-cosmos/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
