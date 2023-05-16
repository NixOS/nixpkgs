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
<<<<<<< HEAD
  version = "7.11.1";
=======
  version = "7.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-iWbHtpFSiQTcpSQ6S8lrUWAi9kjesh1ZvKPVvNquxYU=";
=======
    hash = "sha256-ANEJ5aLqfHX/OGO41FNjCqr9S6UygQMrGMQvMtR3z/Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
