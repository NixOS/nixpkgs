{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, arviz
, formulae
, graphviz
, numpy
, pandas
, pymc
, scipy
}:

buildPythonPackage rec {
  pname = "bambi";
  version = "0.9.3";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-f/4CrFmma+Lc6wZm+YyDupDWfPAtuRsZdRf28sYUWTk=";
  };

  propagatedBuildInputs = [
    arviz
    formulae
    numpy
    pandas
    pymc
    scipy
  ];

  preCheck = ''export HOME=$(mktemp -d)'';

  nativeCheckInputs = [ graphviz pytestCheckHook ];
  disabledTests = [
    # attempt to fetch data:
    "test_data_is_copied"
    "test_predict_offset"
    # require blackjax (not in Nixpkgs), numpyro, and jax:
    "test_logistic_regression_categoric_alternative_samplers"
    "test_regression_alternative_samplers"
  ];

  pythonImportsCheck = [ "bambi" ];

  meta = with lib; {
    homepage = "https://bambinos.github.io/bambi";
    description = "High-level Bayesian model-building interface";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
