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
  version = "9.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "36a508fe40f904723485586e9088092e6f65cdb82bc86efc42d615499c256829";
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
