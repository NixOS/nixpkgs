{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, pytest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pytest-env";
<<<<<<< HEAD
  version = "0.8.2";
=======
  version = "0.8.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  src = fetchPypi {
    pname = "pytest_env";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-uu2bO2uud711uSOODtHuaQOkKAaunWrv+4dUzVWE1P8=";
=======
    hash = "sha256-17L1Jz7G0eIhdXmYvC9Q0kdO19C5MxuSVWAR+txOmr8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Pytest plugin used to set environment variables";
    homepage = "https://github.com/MobileDynasty/pytest-env";
    license = licenses.mit;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
