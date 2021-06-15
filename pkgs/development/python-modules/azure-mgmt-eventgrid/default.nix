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
  version = "9.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "aecbb69ecb010126c03668ca7c9a2be8e965568f5b560f0e7b5bc152b157b510";
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
