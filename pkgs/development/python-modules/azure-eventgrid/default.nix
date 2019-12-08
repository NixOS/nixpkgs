{ lib
, buildPythonPackage
, fetchPypi
, msrest
, azure-common
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-eventgrid";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c82c4bf6ea59aeec69ce8f95f1b6a4edc6d733874aeb056669c9d2806168c86e";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "A fully-managed intelligent event routing service that allows for uniform event consumption using a publish-subscribe model";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
