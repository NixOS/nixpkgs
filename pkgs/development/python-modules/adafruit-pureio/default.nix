{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "adafruit-pureio";
<<<<<<< HEAD
  version = "1.1.11";
  format = "pyproject";
=======
  version = "1.1.10";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Adafruit_PureIO";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-xM+7NlcxlC0fEJKhFvR9/a4K7xjFsn8QcrWCStXqjHw=";
=======
    hash = "sha256-EgaIN1PAlmMJ5tAtqXBnbpvHtQO7Sib3NuAXOfVqZLk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  # Physical SMBus is not present
  doCheck = false;

  pythonImportsCheck = [
    "Adafruit_PureIO"
  ];

  meta = with lib; {
    description = "Python interface to Linux IO including I2C and SPI";
    homepage = "https://github.com/adafruit/Adafruit_Python_PureIO";
    changelog = "https://github.com/adafruit/Adafruit_Python_PureIO/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
