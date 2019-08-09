{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-cosmosdb";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1d9xzf9ydlhwlsk7ij64ji1r2j0l7bwaykwngcy5lh8sdxax305r";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Cosmos DB Management Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-cosmosdb;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
