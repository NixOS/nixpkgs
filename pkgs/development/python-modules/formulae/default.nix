{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, numpy
, pandas
, scipy
}:

buildPythonPackage rec {
  pname = "formulae";
  version = "0.3.4";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-6IGTn3griooslN6+qRYLJiWaJhvsxa1xj1+1kQ57yN0=";
  };

  propagatedBuildInputs = [
    numpy
    pandas
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  # use assertions of form `assert pytest.approx(...)`, which is now disallowed:
  disabledTests = [ "test_basic" "test_degree" ];
  pythonImportsCheck = [
    "formulae"
    "formulae.matrices"
  ];

  meta = with lib; {
    homepage = "https://bambinos.github.io/formulae";
    description = "Formulas for mixed-effects models in Python";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
