{ lib
<<<<<<< HEAD
, azure-common
, azure-mgmt-core
, buildPythonPackage
, fetchPypi
, isodate
, pythonOlder
, typing-extensions
=======
, buildPythonPackage
, fetchPypi
, pythonOlder
, msrest
, msrestazure
, azure-common
, azure-mgmt-core
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "azure-mgmt-monitor";
<<<<<<< HEAD
  version = "6.0.2";
=======
  version = "6.0.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-X/v1AOSZq3kSsbptJs7yZIDZrkEVMgGbt41yViGW4Hs=";
  };

  propagatedBuildInputs = [
    isodate
    azure-common
    azure-mgmt-core
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
=======
    extension = "zip";
    hash = "sha256-Uhs+wz3sB5mOt1LGJCqzhMT5YWwwMnpmVi4WvXHBfZY=";
  };

  propagatedBuildInputs = [
    msrest
    msrestazure
    azure-common
    azure-mgmt-core
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  pythonNamespaces = [
    "azure.mgmt"
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Monitor Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
