{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # dependencies
  google-generativeai,
  joblib,
  networkx,
  numpy,
  opt-einsum,
  pandas,
  pyparsing,
  pyro-ppl,
  scikit-learn,
  scipy,
  statsmodels,
  torch,
  tqdm,
  xgboost,

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
    google-generativeai
    joblib
    networkx
    numpy
    opt-einsum
    pandas
    pyparsing
    pyro-ppl
    scikit-learn
    scipy
    statsmodels
    torch
    tqdm
    xgboost
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

    # AssertionError
    "test_estimate_example_smoke_test"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    # xdoctest
    pytest-cov-stub
    coverage
    mock
    black
  ];

  pythonImportsCheck = [ "pgmpy" ];

  meta = {
    description = "Python Library for learning (Structure and Parameter), inference (Probabilistic and Causal), and simulations in Bayesian Networks";
    homepage = "https://github.com/pgmpy/pgmpy";
    changelog = "https://github.com/pgmpy/pgmpy/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
