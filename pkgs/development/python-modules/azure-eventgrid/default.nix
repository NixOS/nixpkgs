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
  version = "4.1.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c3bd28ccf6c837b58b58fc61275dace5348a823660c3ca21166a88aa2a8377a4";
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
