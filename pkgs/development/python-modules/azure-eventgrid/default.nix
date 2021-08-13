{ lib
, buildPythonPackage
, fetchPypi
, msrest
, azure-common
, azure-core
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-eventgrid";
  version = "4.5.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "41ce94305fd3c4e2534f7663fb1be79819fc7d59f2b20544593ea6c914839351";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
    msrestazure
  ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "azure.eventgrid" ];

  meta = with lib; {
    description = "A fully-managed intelligent event routing service that allows for uniform event consumption using a publish-subscribe model";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
