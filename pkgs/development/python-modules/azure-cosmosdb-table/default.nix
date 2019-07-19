{ lib, buildAzureCosmosdbPythonPackage, fetchPypi, isPy3k
, azure-common
, azure-cosmosdb-nspkg
, azure-nspkg
, azure-storage-common
, cryptography
, dateutil
, futures
, requests
}:

buildAzureCosmosdbPythonPackage rec {
  version = "1.0.5";
  pname = "azure-cosmosdb-table";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0i81iikkrdjkck4jqm76xsf1wdb7p4549x0i70mgqsh3jb3w4d2a";
  };

  propagatedBuildInputs = [
    azure-common
    azure-cosmosdb-nspkg
    azure-nspkg
    azure-storage-common
    cryptography
    dateutil
    requests
  ] ++ lib.optionals (!isPy3k) [ futures ];

  # tests are weird with namespace packages
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure CosmosDB Table Client Library for Python";
    homepage = "https://github.com/Azure/azure-cosmosdb-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight jonringer ];
  };
}
