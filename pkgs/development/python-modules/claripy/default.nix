{ lib
, buildPythonPackage
, cachetools
, decorator
, fetchFromGitHub
, pysmt
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
, setuptools
, z3-solver
}:

buildPythonPackage rec {
  pname = "claripy";
  version = "9.2.96";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "claripy";
    rev = "refs/tags/v${version}";
    hash = "sha256-rXJzJCyhsScFW1L/mVARciGDlOOBCFT69VBivjV6oig=";
  };

  # z3 does not provide a dist-info, so python-runtime-deps-check will fail
  pythonRemoveDeps = [
    "z3-solver"
  ];

  build-system = [
    pythonRelaxDepsHook
    setuptools
  ];

  dependencies = [
    cachetools
    decorator
    pysmt
    z3-solver
  ] ++ z3-solver.requiredPythonModules;

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
