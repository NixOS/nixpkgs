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
  pname = "azure-mgmt-eventhub";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1nnp2ki4iz4f4897psmwb0v5khrwh84fgxja7nl7g73g3ym20sz8";
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
    description = "This is the Microsoft Azure EventHub Management Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/event-hub?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
