{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  flit-core,
  z3-solver,
  astroid,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "deal-solver";
  version = "0.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "life4";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-DAOeQLFR/JED32uJSW7W9+Xx5f1Et05W8Fp+Vm7sfZo=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  # z3 does not provide a dist-info, so python-runtime-deps-check will fail
  pythonRemoveDeps = [ "z3-solver" ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "\"--cov=deal_solver\"," "" \
      --replace-fail "\"--cov-report=html\"," "" \
      --replace-fail "\"--cov-report=xml\"," "" \
      --replace-fail "\"--cov-report=term-missing:skip-covered\"," "" \
      --replace-fail "\"--cov-fail-under=100\"," ""
  '';

  propagatedBuildInputs = [
    z3-solver
    astroid
  ] ++ z3-solver.requiredPythonModules;

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "deal_solver" ];

  meta = with lib; {
    description = "Z3-powered solver (theorem prover) for deal";
    homepage = "https://github.com/life4/deal-solver";
    changelog = "https://github.com/life4/deal-solver/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
