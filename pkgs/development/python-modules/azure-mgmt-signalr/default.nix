{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-nspkg
}:

buildPythonPackage rec {
  pname = "azure-mgmt-signalr";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "8a6266a59a5c69102e274806ccad3ac74b06fd2c226e16426bbe248fc2174903";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-nspkg
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure SignalR Client Library";
    homepage = https://github.com/Azure/azure-sdk-for-python/tree/master/azure-mgmt-signalr;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
