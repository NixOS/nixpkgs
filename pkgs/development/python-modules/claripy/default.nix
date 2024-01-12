{ lib
, buildPythonPackage
, setuptools
, cachetools
, decorator
, fetchFromGitHub
, future
, pysmt
, pythonOlder
, pytestCheckHook
, z3-solver
}:

buildPythonPackage rec {
  pname = "claripy";
  version = "9.2.84";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "claripy";
    rev = "refs/tags/v${version}";
    hash = "sha256-wgCWMngda0gB+AEDFpRxQ2ots5YXE4bkBSxMtYJqLEo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cachetools
    decorator
    future
    pysmt
    z3-solver
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "claripy"
  ];

  meta = with lib; {
    description = "Python abstraction layer for constraint solvers";
    homepage = "https://github.com/angr/claripy";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
