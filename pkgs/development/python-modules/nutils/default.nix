{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, numpy
, treelog
, stringly
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nutils";
  version = "7.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "evalf";
    repo = "nutils";
    rev = "refs/tags/v${version}";
    hash = "sha256-KCvUBE3qbX6v1HahBj4/jjM8ujvFGtWNuH1D+bTHrQ0=";
  };

  propagatedBuildInputs = [
    numpy
    treelog
    stringly
  ];

  checkInputs = [
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
    homepage = "https://www.nutils.org/";
    license = licenses.mit;
    broken = stdenv.hostPlatform.isAarch64;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
