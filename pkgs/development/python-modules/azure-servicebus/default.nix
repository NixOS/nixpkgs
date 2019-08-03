{ lib
, buildPythonPackage
, fetchPypi
, uamqp
, azure-common
, msrestazure
, futures
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-servicebus";
  version = "0.50.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c5864cfc69402e3e2897e61b3bd224ade28d9e33dad849e4bd6afad26a3d2786";
  };

  buildInputs = [
    uamqp
    azure-common
    msrestazure
  ] ++ lib.optionals (!isPy3k) [
    futures
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Service Bus Client Library";
    homepage = https://github.com/Azure/azure-sdk-for-python/free/master/azure-servicebus;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
