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
  pname = "azure-mgmt-eventgrid";
  version = "10.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "4da3bf142d31bc25d80ee26641b95b7f52eb1baf4f326b9954e9f0613944ef3c";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-mgmt-core
    azure-common
  ] ++ lib.optionals (!isPy3k) [
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "azure.mgmt.eventgrid" ];

  meta = with lib; {
    description = "This is the Microsoft Azure EventGrid Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
