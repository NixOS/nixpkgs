{ lib, buildAzureCosmosdbPythonPackage, fetchPypi, isPy3k
, azure-common
, azure-cosmosdb-nspkg
, azure-nspkg
, azure-storage-common
, cryptography
, dateutil
, futures
, requests
, vcrpy
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
    description = "This is the Microsoft Azure Log Analytics Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/cosmosdb?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight jonringer ];
  };
}
