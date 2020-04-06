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
  version = "0.50.2";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "836649d510aa2b7467bc87d8dab18f2db917b63aa2fe8f3e5d0bb44011e465f5";
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
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
