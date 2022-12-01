{ lib
, amply
, buildPythonPackage
, fetchFromGitHub
, pyparsing
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pulp";
  version = "2.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "coin-or";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-j0f6OiscJyTqPNyLp0qWRjCGLWuT3HdU1S/sxpnsiMo=";
  };

  propagatedBuildInputs = [
    amply
    pyparsing
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pulp"
  ];

  disabledTests = [
    # The solver is not available
    "PULP_CBC_CMDTest"
    "test_examples"
  ];

  meta = with lib; {
    description = "Module to generate  generate MPS or LP files";
    homepage = "https://github.com/coin-or/pulp";
    license = licenses.mit;
    maintainers = with maintainers; [ teto ];
  };
}
