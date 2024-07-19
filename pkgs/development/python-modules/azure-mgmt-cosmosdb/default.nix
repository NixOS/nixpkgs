{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cosmosdb";
  version = "9.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TlXTlz8RzwLPeoBVruhmFSM9fL47siegfBdrrIvH7wI=";
  };

  propagatedBuildInputs = [
    isodate
    azure-common
    azure-mgmt-core
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.cosmosdb" ];

  meta = with lib; {
    description = "Module to work with the Microsoft Azure Cosmos DB Management";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-cosmosdb_${version}/sdk/cosmos/azure-mgmt-cosmosdb/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
