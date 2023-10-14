{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, flit-core
, z3
, astroid
, pytestCheckHook
, hypothesis
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

  postPatch = ''
    # Use upstream z3 implementation
    substituteInPlace pyproject.toml \
      --replace "\"z3-solver\"," "" \
      --replace "\"--cov=deal_solver\"," "" \
      --replace "\"--cov-report=html\"," "" \
      --replace "\"--cov-report=xml\"," "" \
      --replace "\"--cov-report=term-missing:skip-covered\"," "" \
      --replace "\"--cov-fail-under=100\"," ""
  '';

  propagatedBuildInputs = [
    z3
    astroid
  ] ++ z3.requiredPythonModules;

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
