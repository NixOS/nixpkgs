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
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "08b2i6wz9n13h77ahay1hvmg8abk2vvs7kn4y7xip9gi6ij8fv0a";
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
