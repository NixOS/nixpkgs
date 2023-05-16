{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "adafruit-platformdetect";
<<<<<<< HEAD
  version = "3.51.0";
=======
  version = "3.46.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Adafruit-PlatformDetect";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-/a0IKOFWnXC6BJItpJDqiA9aCB1PNhglNlB/4KvyQdg=";
=======
    hash = "sha256-d8RhnMcTeHFDpVS+c5lETRz75vFPOMIaqbqPGVG4vHY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  # Project has not published tests yet
  doCheck = false;

  pythonImportsCheck = [
    "adafruit_platformdetect"
  ];

  meta = with lib; {
    description = "Platform detection for use by Adafruit libraries";
    homepage = "https://github.com/adafruit/Adafruit_Python_PlatformDetect";
    changelog = "https://github.com/adafruit/Adafruit_Python_PlatformDetect/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
