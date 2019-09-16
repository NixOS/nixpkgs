{ buildPythonPackage
, lib
, fetchPypi
, six
, requests
}:

buildPythonPackage rec {
  version = "2.3.3";
  pname = "pydocumentdb";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fcp3g62pc9hpa0r6vdjhaln4h0azywjqfzi8bd4414ja0mxmj3p";
  };

  propagatedBuildInputs = [ six requests ];

  # requires an active Azure Cosmos service
  doCheck = false;

  meta = with lib; {
    description = "Azure Cosmos DB API";
    homepage = https://github.com/Azure/azure-cosmos-python;
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
