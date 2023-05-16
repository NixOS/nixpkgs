{ lib
, buildPythonPackage
, fetchPypi
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-mgmt-recoveryservices";
<<<<<<< HEAD
  version = "2.4.0";
=======
  version = "2.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
<<<<<<< HEAD
    hash = "sha256-2JeOvtNxx6Z3AY4GI9fBRKbMcYVHsbrhk8C+5t5eelk=";
=======
    hash = "sha256-4L6Tqgvqh+nJyeXMolSpQ/2knAED75RQqD/lUDOt5ek=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.mgmt.recoveryservices"
  ];

  meta = with lib; {
    description = "This is the Microsoft Azure Recovery Services Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
