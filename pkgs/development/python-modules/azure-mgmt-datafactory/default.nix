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
  pname = "azure-mgmt-datafactory";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-pjBjFPkKhKd8XI6wmzX/rAssHINMzDAZa+XRqG/pLYo=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Data Factory Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
