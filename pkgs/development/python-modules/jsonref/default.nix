{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, pdm-backend
, pdm-pep517
, pytestCheckHook
, pythonOlder
=======
, poetry-core
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "jsonref";
<<<<<<< HEAD
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

=======
  version = "1.0.1";
  format = "pyproject";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "gazpachoking";
    repo = "jsonref";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-tOhabmqCkktJUZjCrzjOjUGgA/X6EVz0KqehyLtigfc=";
  };

  nativeBuildInputs = [
    pdm-backend
    pdm-pep517
=======
    hash = "sha256-8p0BmDZGpQ6Dl9rkqRKZKc0doG5pyXpfcVpemmetLhs=";
  };

  nativeBuildInputs = [
    poetry-core
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "tests.py"
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "jsonref"
  ];

  meta = with lib; {
    description = "An implementation of JSON Reference for Python";
    homepage = "https://github.com/gazpachoking/jsonref";
    changelog = "https://github.com/gazpachoking/jsonref/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
=======
  meta = with lib; {
    description = "An implementation of JSON Reference for Python";
    homepage    = "https://github.com/gazpachoking/jsonref";
    license     = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms   = platforms.all;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
