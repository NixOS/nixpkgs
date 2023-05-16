{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
<<<<<<< HEAD
, pytest-mock
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "filelock";
<<<<<<< HEAD
  version = "3.12.2";
=======
  version = "3.9.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-ACdAUY2KpZomsMduEPuMbhXq6CXTS2/fZwMz/XuTjYE=";
=======
    hash = "sha256-ezGfJDQLUfVaK/ehKsB1WpsD5xgxHaxWeg9Pf6vS9d4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
    pytest-mock
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/tox-dev/py-filelock/releases/tag/${version}";
    description = "A platform independent file lock for Python";
    homepage = "https://github.com/benediktschmitt/py-filelock";
    license = licenses.unlicense;
    maintainers = with maintainers; [ hyphon81 ];
  };
}
