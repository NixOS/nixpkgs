{ lib
, azure-common
, azure-core
, buildPythonPackage
, fetchPypi
, futures ? null
, isodate
, isPy3k
, msrestazure
, uamqp
}:

buildPythonPackage rec {
  pname = "azure-servicebus";
  version = "7.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "e97a069c6a73fce3042a5ef0d438cc564152cfbcc2e7db6f7a19fbd51bb3555b";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    isodate
    msrestazure
    uamqp
  ] ++ lib.optionals (!isPy3k) [
    futures
  ];

  # has no tests
  doCheck = false;

  # python2 will fail due to pep 420
  pythonImportsCheck = lib.optionals isPy3k [
    "azure.servicebus"
  ];

  meta = with lib; {
    description = "Microsoft Azure Service Bus Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
