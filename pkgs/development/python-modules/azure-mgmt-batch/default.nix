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
  pname = "azure-mgmt-batch";
  version = "6.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "dc929d2a0a65804c28a75dc00bb84ba581f805582a09238f4e7faacb15f8a2a3";
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
    description = "This is the Microsoft Azure Batch Management Client Library";
    homepage = https://github.com/Azure/sdk-for-python/tree/master/azure-mgmt-batch;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
