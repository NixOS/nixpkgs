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
  version = "7.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-iWbHtpFSiQTcpSQ6S8lrUWAi9kjesh1ZvKPVvNquxYU=";
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
