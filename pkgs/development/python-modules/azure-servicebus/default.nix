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
  version = "0.50.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "0i8ls5h2ny12h9gnqwyq13ysvxgdq7b1kxirj4n58dfy94a182gv";
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
