{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, pytestCheckHook
, numpy
, pandas
, scipy
}:

buildPythonPackage rec {
  pname = "formulae";
  version = "0.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-WDWpyrHXGBfheE0m5I9K+Dk1urXRMY6yoenN3OaZogM=";
  };

  nativeBuildInputs = [ setuptools ];

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
    changelog = "https://github.com/bambinos/formulae/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
