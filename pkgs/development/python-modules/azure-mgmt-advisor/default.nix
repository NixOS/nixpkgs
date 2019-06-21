{ lib, buildAzureMgmtPythonPackage, fetchPypi, isPy3k, python
, azure-common
, azure-mgmt-nspkg
, msrest
, msrestazure
}:

buildAzureMgmtPythonPackage rec {
  version = "2.0.1";
  pname = "azure-mgmt-advisor";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1929d6d5ba49d055fdc806e981b93cf75ea42ba35f78222aaf42d8dcf29d4ef3";
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
    description = "This is the Microsoft Azure Advisor Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/advisor/azure-mgmt-advisor";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight jonringer ];
  };
}
