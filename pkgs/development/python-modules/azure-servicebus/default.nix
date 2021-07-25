{ lib
, buildPythonPackage
, fetchPypi
, uamqp
, azure-common
, azure-core
, msrestazure
, futures ? null
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-servicebus";
  version = "7.3.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "dc162fc572087cdf53065a2ea9517b002a6702cf382f998d69903d68c16c731e";
  };

  propagatedBuildInputs = [
    uamqp
    azure-common
    azure-core
    msrestazure
  ] ++ lib.optionals (!isPy3k) [
    futures
  ];

  # has no tests
  doCheck = false;

  # python2 will fail due to pep 420
  pythonImportsCheck = lib.optionals isPy3k [ "azure.servicebus" ];

  meta = with lib; {
    description = "Microsoft Azure Service Bus Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
