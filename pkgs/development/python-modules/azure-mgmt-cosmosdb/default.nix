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
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "3f6c1369903856864c7e4a05c2c261563153597172b182382d6332f3acd04016";
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
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
