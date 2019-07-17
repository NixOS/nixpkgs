{ lib, buildAzureCosmosdbPythonPackage, fetchPypi
, azure-nspkg
}:

buildAzureCosmosdbPythonPackage rec {
  version = "2.0.2";
  pname = "azure-cosmosdb-nspkg";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n4wl1dr18sy5rjvlss9vh5mrqxqbr4a7iskqrjrm3c1jbk93xmc";
  };

  propagatedBuildInputs = [ azure-nspkg ];

  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure CosmosDB namespace package";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight jonringer ];
  };
}
