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
  version = "7.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-uZGxQ1Vl6wpBCMW1+80/CBuqelLV02yXf1sNlNtCpHU=";
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
