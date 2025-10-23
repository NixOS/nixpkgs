{
  lib,
  astroid,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  hypothesis,
  pytest-cov-stub,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  z3-solver,
}:

buildPythonPackage rec {
  pname = "deal-solver";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "life4";
    repo = "deal-solver";
    tag = version;
    hash = "sha256-DAOeQLFR/JED32uJSW7W9+Xx5f1Et05W8Fp+Vm7sfZo=";
  };

  build-system = [ flit-core ];

  # z3 does not provide a dist-info, so python-runtime-deps-check will fail
  pythonRemoveDeps = [ "z3-solver" ];

  dependencies = [
    z3-solver
    astroid
  ]
  ++ z3-solver.requiredPythonModules;

  nativeCheckInputs = [
    hypothesis
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "deal_solver" ];

  disabledTests = [
    # Flaky tests, sometimes it works sometimes it doesn't
    "test_expr_asserts_ok"
    "test_fuzz_math_floats"
  ];

  meta = with lib; {
    description = "Z3-powered solver (theorem prover) for deal";
    homepage = "https://github.com/life4/deal-solver";
    changelog = "https://github.com/life4/deal-solver/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
