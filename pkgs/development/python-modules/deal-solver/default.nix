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
  version = "0.1.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "life4";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-eSSyLBwPc0rrfew91nLBagYDD6aJRyx0cE9YTTSODI8=";
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
  ];

  checkInputs = [
    pytestCheckHook
    hypothesis
  ];

  disabledTests = [
    # z3 assertion error
    "test_expr_asserts_ok"
  ];

  disabledTestPaths = [
    # regex matching seems flaky on tests
    "tests/test_stdlib/test_re.py"
  ];

  pythonImportsCheck = [ "deal_solver" ];

  meta = with lib; {
    description = "Z3-powered solver (theorem prover) for deal";
    homepage = "https://github.com/life4/deal-solver";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
