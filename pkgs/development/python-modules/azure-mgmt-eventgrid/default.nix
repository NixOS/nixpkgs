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
  version = "8.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "a8a6e1bb105a14f1d3545ecb07c190370f21a145f8ba51599ed169f1dc8d5dcc";
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
