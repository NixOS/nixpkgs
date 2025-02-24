{
  lib,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-cosmos";
  version = "4.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_cosmos";
    inherit version;
    hash = "sha256-xw20y/VbD/Jh7Xu4qjJaXfpWXTxuqkPXXSauXirW108=";
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

  meta = with lib; {
    description = "Azure Cosmos DB API";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/cosmos/azure-cosmos";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-cosmos_${version}/sdk/cosmos/azure-cosmos/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
