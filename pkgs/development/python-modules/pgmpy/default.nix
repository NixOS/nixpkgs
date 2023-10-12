{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
# build inputs
, networkx
, numpy
, scipy
, scikit-learn
, pandas
, pyparsing
, torch
, statsmodels
, tqdm
, joblib
, opt-einsum
# check inputs
, pytestCheckHook
, pytest-cov
, coverage
, mock
, black
}:
let
  pname = "pgmpy";
  version = "0.1.23";
  # optional-dependencies = {
  #   all = [ daft ];
  # };
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pgmpy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4NY37Awhu2mnfZQ/biN1wa9rkGHhTxfZm0+V7D83NR0=";
  };

  propagatedBuildInputs = [
    networkx
    numpy
    scipy
    scikit-learn
    pandas
    pyparsing
    torch
    statsmodels
    tqdm
    joblib
    opt-einsum
  ];

  disabledTests = [
    "test_to_daft" # requires optional dependency daft
  ];

  nativeCheckInputs = [
    pytestCheckHook
    # xdoctest
    pytest-cov
    coverage
    mock
    black
  ];

  meta = with lib; {
    description = "Python Library for learning (Structure and Parameter), inference (Probabilistic and Causal), and simulations in Bayesian Networks";
    homepage = "https://github.com/pgmpy/pgmpy";
    changelog = "https://github.com/pgmpy/pgmpy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
  };
}
