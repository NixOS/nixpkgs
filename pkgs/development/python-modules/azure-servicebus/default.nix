{ lib
, azure-common
, azure-core
, buildPythonPackage
, fetchPypi
, isodate
, msrestazure
, pythonOlder
, six
, typing-extensions
, uamqp
}:

buildPythonPackage rec {
  pname = "azure-servicebus";
  version = "7.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-JMmfs1d1EFilHJ1Dud4mGJynRHLx+Uq95nZM2D+NecE=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    isodate
    msrestazure
    six
    typing-extensions
    uamqp
  ];

  # Tests require dev-tools
  doCheck = false;

  pythonImportsCheck = [
    "azure.servicebus"
  ];

  meta = with lib; {
    description = "Microsoft Azure Service Bus Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
