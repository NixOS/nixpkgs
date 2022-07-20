{ buildPythonPackage
, lib
, fetchPypi
, six
, requests
, azure-core
}:

buildPythonPackage rec {
  version = "4.2.0";
  pname = "azure-cosmos";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "867191fa5966446101f7ca3834f23060a85735d0b660303ca353864945d572b6";
  };

  propagatedBuildInputs = [ six requests azure-core ];

  pythonNamespaces = [ "azure" ];

  # requires an active Azure Cosmos service
  doCheck = false;

  meta = with lib; {
    description = "Azure Cosmos DB API";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
