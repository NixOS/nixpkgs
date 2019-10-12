{ lib
, buildPythonPackage
, fetchPypi
, azure-nspkg
}:

buildPythonPackage rec {
  pname = "azure-cosmosdb-nspkg";
  version = "2.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "acf691e692818d9a65c653c7a3485eb8e35c0bdc496bba652e5ea3905ba09cd8";
  };

  propagatedBuildInputs = [
    azure-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure CosmosDB namespace package";
    homepage = https://github.com/Azure/azure-cosmos-table-python/tree/master/azure-cosmosdb-nspkg;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
