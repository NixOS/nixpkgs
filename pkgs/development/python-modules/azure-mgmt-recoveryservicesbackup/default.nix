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
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "d3e60daefbc20a7fa381c7ad1498f4bf4bb5a1414c1c64188cc9d5c98c4e12ac";
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
