{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
, azure-mgmt-nspkg
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-mgmt-rdbms";
  version = "9.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "f738d9e6db8f6da6bb4e84e59dd0548c8adef948357a447337e78d1035ac960a";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "azure.mgmt.rdbms" ];

  meta = with lib; {
    description = "This is the Microsoft Azure RDBMS Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
