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
  pname = "azure-mgmt-subscription";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "7a095fe46e598210b178e1059bba82eb02f3b8a7f44f3791442ff7d9ff323d2b";
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
    description = "This is the Microsoft Azure Subscription Management Client Library";
    homepage = https://github.com/Azure/azure-sdk-for-python/tree/master/azure-mgmt-subscription;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
