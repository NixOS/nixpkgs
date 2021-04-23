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
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c4f29b2d9b717dad7919048f0a458dd84f83637c3d5c8f5a7e64634b22086719";
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
