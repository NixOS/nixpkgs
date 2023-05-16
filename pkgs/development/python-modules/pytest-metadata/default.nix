{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, hatch-vcs
, hatchling
, pytest
, pytestCheckHook
, pythonOlder
=======
, poetry-core
, pytest
, pytestCheckHook
, pythonOlder
, setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "pytest-metadata";
<<<<<<< HEAD
  version = "3.0.0";
=======
  version = "2.0.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pytest_metadata";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-dpqcZdKIS9WDvGJrCs53rRXb4C3ZGpEG1H/UbZwlaco=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
=======
    hash = "sha256-/MZT9l/jA1tHiCC1KE+/D1KANiLuP2Ci+u16fTuh9B4=";
  };

  nativeBuildInputs = [
    poetry-core
    setuptools-scm
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Plugin for accessing test session metadata";
    homepage = "https://github.com/pytest-dev/pytest-metadata";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mpoquet ];
  };
}
