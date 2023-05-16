{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, flit-core
, freezegun
=======
, freezegun
, hatchling
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytest
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-freezer";
<<<<<<< HEAD
  version = "0.4.8";
=======
  version = "0.4.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-Eak6LNoyu2wvZbPaBBUO0UkyB9vni8YbsADGK0as7Cg=";
  };

  nativeBuildInputs = [
    flit-core
=======
    hash = "sha256-0JZv6MavRceAV+ZOetCVxJEyttd5W3PCts6Fz2KQsh0=";
  };

  nativeBuildInputs = [
    hatchling
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    freezegun
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_freezer"
  ];

  meta = with lib; {
    description = "Pytest plugin providing a fixture interface for spulec/freezegun";
    homepage = "https://github.com/pytest-dev/pytest-freezer";
    changelog = "https://github.com/pytest-dev/pytest-freezer/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
