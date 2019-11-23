{ buildPythonPackage
, lib
, fetchPypi
, six
, requests
}:

buildPythonPackage rec {
  version = "3.1.2";
  pname = "azure-cosmos";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f8ac99e4e40c398089fc383bfadcdc83376f72b88532b0cac0b420357cd08c7";
  };

  propagatedBuildInputs = [ six requests ];

  # requires an active Azure Cosmos service
  doCheck = false;

  meta = with lib; {
    description = "Azure Cosmos DB API";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
