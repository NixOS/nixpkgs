{ lib
, buildPythonPackage
, fetchPypi
, pyserial
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-velbus";
<<<<<<< HEAD
  version = "2.1.12";
=======
  version = "2.1.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-X0jg1qd4rWbaRZqgMBJKOZD50sFq3Eyhw9RU6cEjORo=";
=======
    hash = "sha256-SbuECT6851E+QNyyPaNTnKmH54fYovemSto8gvfMIKg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pyserial
  ];

  # Project has not tests
  doCheck = false;

  pythonImportsCheck = [
    "velbus"
  ];

  meta = with lib; {
    description = "Python library to control the Velbus home automation system";
    homepage = "https://github.com/thomasdelaet/python-velbus";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
