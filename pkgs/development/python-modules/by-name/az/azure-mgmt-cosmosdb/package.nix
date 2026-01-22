{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cosmosdb";
  version = "9.8.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_cosmosdb";
    inherit version;
    hash = "sha256-IU7kcWU4flePhuZhH7MptNVNwpWtedo3udksXW0g0bE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    isodate
    azure-common
    azure-mgmt-core
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.cosmosdb" ];

  meta = {
    description = "Module to work with the Microsoft Azure Cosmos DB Management";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-cosmosdb_${version}/sdk/cosmos/azure-mgmt-cosmosdb/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
