{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-recoveryservicesbackup";
  version = "4.1.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-9xF2TIAzydmviOwfveA0ZGP7Qj0HWLL6rXp4V4IDS6A=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.recoveryservicesbackup" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Recovery Services Backup Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
