{
  lib,
  buildPythonPackage,
  cachetools,
  decorator,
  fetchFromGitHub,
  pysmt,
  pytestCheckHook,
  setuptools,
  typing-extensions,
  z3-solver,
}:

buildPythonPackage rec {
  pname = "claripy";
  version = "9.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "angr";
    repo = "claripy";
    tag = "v${version}";
    hash = "sha256-TjZ06LfVe7N8a2g/t1X+xkSRXAzKyhsflPrdbcr8kME=";
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
