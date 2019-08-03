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
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0g4znanx540p983gzr55z0n0jyzfnzmnzlshl92hm4gldwjdd91d";
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
