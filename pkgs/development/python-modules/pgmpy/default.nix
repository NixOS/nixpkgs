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
  scikit-base,
  scikit-learn,
  scipy,
  statsmodels,
  torch,
  tqdm,
  xgboost,

  # tests
  pytestCheckHook,
  pytest-cov-stub,
  mock,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "pgmpy";
  version = "1.0.0-unstable-2025-12-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pgmpy";
    repo = "pgmpy";
    rev = "197e1e0444c77c00581a4c32763811e5b03f8503";
    hash = "sha256-TCnn3GrITW8HCrYVeeythiULV130b6uulkijkPpJOqA=";
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
    scikit-base
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
    "test_gcm"
  ];

  enabledTestPaths = [
    "pgmpy/tests"
  ];

  disabledTestPaths = [
    # requires network access
    "pgmpy/tests/test_datasets"

    # Very slow
    "pgmpy/tests/test_estimators"
    "pgmpy/tests/test_models"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    # xdoctest
    pytest-cov-stub
    mock
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "pgmpy" ];

  meta = {
    description = "Python Library for learning (Structure and Parameter), inference (Probabilistic and Causal), and simulations in Bayesian Networks";
    homepage = "https://github.com/pgmpy/pgmpy";
    # changelog = "https://github.com/pgmpy/pgmpy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      happysalada
      sarahec
    ];
  };
})
