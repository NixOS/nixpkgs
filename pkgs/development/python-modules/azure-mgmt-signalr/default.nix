{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-mgmt-signalr";
<<<<<<< HEAD
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-jbFhVoJbObpvcVJr2VoUzY5CmSblJ6OK7Q3l17SARfg=";
=======
    hash = "sha256-lUNIDyP5W+8aIX7manfMqaO2IJJm/+2O+Buv+Bh4EZE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure SignalR Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
