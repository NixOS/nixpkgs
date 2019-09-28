{ buildPythonPackage
, lib
, fetchPypi
, six
, requests
}:

buildPythonPackage rec {
  version = "3.1.1";
  pname = "azure-cosmos";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0q8pl8wnadxhyawcrfzrm2k85xd4mdmdk2xwdial55zmpa8ji4pk";
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
