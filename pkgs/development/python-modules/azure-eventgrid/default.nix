{ lib
, buildPythonPackage
, fetchPypi
, msrest
, azure-common
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-eventgrid";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "7ebbe1c4266ba176aa4969d9755c08f10b89848ad50fb0bfd16fa82e29234f95";
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
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/event-grid?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
