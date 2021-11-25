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
  version = "7.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-nlt4wNHI613tK7JB85fBW2LE/FOa8+2aLeT6wzP1PQ4=";
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
