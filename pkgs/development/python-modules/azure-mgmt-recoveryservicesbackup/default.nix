{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-recoveryservicesbackup";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1e55b6cbb808df83576cef352ba0065f4878fe505299c0a4c5a97f4f1e5793df";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Recovery Services Backup Management Client Library";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/recovery-services-backup?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
