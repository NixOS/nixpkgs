{
  lib,
  buildPythonPackage,
  cachetools,
  decorator,
  fetchFromGitHub,
  pysmt,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
  z3-solver,
}:

buildPythonPackage rec {
  pname = "claripy";
  version = "9.2.193";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "claripy";
    tag = "v${version}";
    hash = "sha256-nZ7ORbhi0R79pcHpkx/lRVdfUsoutCqU+zHX8AICTUE=";
  };

  # z3 does not provide a dist-info, so python-runtime-deps-check will fail
  pythonRemoveDeps = [ "z3-solver" ];

  build-system = [
    setuptools
  ];

  dependencies = [
    cachetools
    decorator
    pysmt
    typing-extensions
    z3-solver
  ]
  ++ z3-solver.requiredPythonModules;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "claripy" ];

  meta = {
    description = "Python abstraction layer for constraint solvers";
    homepage = "https://github.com/angr/claripy";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
}
