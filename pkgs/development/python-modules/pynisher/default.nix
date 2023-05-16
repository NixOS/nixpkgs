{ lib
, buildPythonPackage
, fetchPypi
, psutil
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pynisher";
<<<<<<< HEAD
  version = "1.0.9";
=======
  version = "1.0.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-hlN5uUlgmcipQqmr22rB245oEXOUe5WB9jWo7MXXViE=";
=======
    hash = "sha256-usSowgCwGTATiX1dbPpScO9/FI+E567dvGZxAC+zS14=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    psutil
    typing-extensions
  ];

  # No tests in the Pypi archive
  doCheck = false;

  pythonImportsCheck = [
    "pynisher"
  ];

  meta = with lib; {
    description = "Module intended to limit a functions resources";
    homepage = "https://github.com/automl/pynisher";
<<<<<<< HEAD
    changelog = "https://github.com/automl/pynisher/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
