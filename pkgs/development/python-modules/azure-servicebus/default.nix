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
  version = "0.50.3";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "2b1e60c81fcf5b6a5bb3ceddb27f24543f479912e39a4706a390a16d8c0a71f4";
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

  # python2 will fail due to pep 420
  pythonImportsCheck = lib.optionals isPy3k [ "azure.servicebus" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Service Bus Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
