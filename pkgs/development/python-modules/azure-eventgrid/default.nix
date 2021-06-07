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
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "77af2c20abde7d8342da7993781605b440aeac0f95c4af13bb87465c3bd5fe35";
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
