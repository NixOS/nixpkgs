{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  networkx,
  numpy,
  scipy,
  scikit-learn,
  pandas,
  pyparsing,
  torch,
  statsmodels,
  tqdm,
  joblib,
  opt-einsum,
  xgboost,
  google-generativeai,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
  coverage,
  mock,
  black,
}:
buildPythonPackage rec {
  pname = "pgmpy";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pgmpy";
    repo = "pgmpy";
    tag = "v${version}";
    hash = "sha256-WmRtek3lN7vEfXqoaZDiaNjMQ7R2PmJ/OEwxOV7m5sE=";
  };

  dependencies = [
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
    xgboost
    google-generativeai
  ];

  disabledTests = [
    # flaky:
    # AssertionError: -45.78899127622197 != -45.788991276221964
    "test_score"

    # self.assertTrue(np.isclose(coef, dep_coefs[i], atol=1e-4))
    # AssertionError: False is not true
    "test_pillai"

    # requires optional dependency daft
    "test_to_daft"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    # xdoctest
    pytest-cov-stub
    coverage
    mock
    black
  ];

  meta = {
    description = "Python Library for learning (Structure and Parameter), inference (Probabilistic and Causal), and simulations in Bayesian Networks";
    homepage = "https://github.com/pgmpy/pgmpy";
    changelog = "https://github.com/pgmpy/pgmpy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
