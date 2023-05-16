{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, numpy
, treelog
, stringly
<<<<<<< HEAD
, flit-core
, bottombar
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nutils";
<<<<<<< HEAD
  version = "7.3";
  format = "pyproject";
=======
  version = "7.2";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "evalf";
    repo = "nutils";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-3VtQFnR8vihxoIyRkbE1a1Rs8Np3/79PWNKReTBZDg8=";
  };

  nativeBuildInputs = [
    flit-core
  ];

=======
    hash = "sha256-KCvUBE3qbX6v1HahBj4/jjM8ujvFGtWNuH1D+bTHrQ0=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    numpy
    treelog
    stringly
<<<<<<< HEAD
    bottombar
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "nutils"
  ];

  disabledTestPaths = [
    # AttributeError: type object 'setup' has no attribute '__code__'
    "tests/test_cli.py"
  ];

  meta = with lib; {
    description = "Numerical Utilities for Finite Element Analysis";
<<<<<<< HEAD
    changelog = "https://github.com/evalf/nutils/releases/tag/v${version}";
    homepage = "https://www.nutils.org/";
    license = licenses.mit;
=======
    homepage = "https://www.nutils.org/";
    license = licenses.mit;
    broken = stdenv.hostPlatform.isAarch64;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
