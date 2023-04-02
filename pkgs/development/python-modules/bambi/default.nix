{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, arviz
, blackjax
, formulae
, graphviz
, numpy
, numpyro
, pandas
, pymc
, scipy
}:

buildPythonPackage rec {
  pname = "bambi";
  version = "0.10.0";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bambinos";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-D04eTAlckEqgKA+59BRljlyneHYoqqZvLYmt/gBLHcU=";
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

  nativeCheckInputs = [
    blackjax
    graphviz
    numpyro
    pytestCheckHook
  ];
  disabledTests = [
    # attempt to fetch data:
    "test_data_is_copied"
    "test_predict_offset"
  ];

  pythonImportsCheck = [ "bambi" ];

  meta = with lib; {
    homepage = "https://bambinos.github.io/bambi";
    description = "High-level Bayesian model-building interface";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
