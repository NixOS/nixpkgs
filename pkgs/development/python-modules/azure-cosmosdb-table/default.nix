{ lib
, buildPythonPackage
, fetchPypi
, cryptography
, azure-common
, azure-storage-common
, azure-cosmosdb-nspkg
, futures
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-cosmosdb-table";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4a34c2c792036afc2a3811f4440ab967351e9ceee6542cc96453b63c678c0145";
  };

  propagatedBuildInputs = [
    cryptography
    azure-common
    azure-storage-common
    azure-cosmosdb-nspkg
  ] ++ lib.optionals (!isPy3k) [
    futures
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Log Analytics Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/cosmosdb?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
