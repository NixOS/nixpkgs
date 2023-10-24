{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, numpy
, treelog
, stringly
, flit-core
, bottombar
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nutils";
  version = "8.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "evalf";
    repo = "nutils";
    rev = "refs/tags/v${version}";
    hash = "sha256-6VvzUKKUB5SkmvC7PFPqGayc51t3PTMPwrxgZI5+jHA=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    numpy
    treelog
    stringly
    bottombar
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
    changelog = "https://github.com/evalf/nutils/releases/tag/v${version}";
    homepage = "https://www.nutils.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
