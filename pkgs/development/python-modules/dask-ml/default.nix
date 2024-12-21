{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,
  setuptools-scm,

  # dependencies
  dask-expr,
  dask-glm,
  distributed,
  multipledispatch,
  numba,
  numpy,
  packaging,
  pandas,
  scikit-learn,
  scipy,
  dask,

  # tests
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dask-ml";
  version = "2024.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-ml";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZiBpCk3b4Tk0Hwb4uapJLEx+Nb/qHFROCnkBTNGDzoU=";
  };

  build-system = [
    hatch-vcs
    hatchling
    setuptools-scm
  ];

  dependencies =
    [
      dask-expr
      dask-glm
      distributed
      multipledispatch
      numba
      numpy
      packaging
      pandas
      scikit-learn
      scipy
    ]
    ++ dask.optional-dependencies.array
    ++ dask.optional-dependencies.dataframe;

  pythonImportsCheck = [
    "dask_ml"
    "dask_ml.naive_bayes"
    "dask_ml.wrappers"
    "dask_ml.utils"
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  disabledTestPaths =
    [
      # AttributeError: 'csr_matrix' object has no attribute 'A'
      # Fixed in https://github.com/dask/dask-ml/pull/996
      "tests/test_svd.py"

      # Tests fail with dask>=0.11.2
      # RuntimeError: Not enough arguments provided
      # Reported in https://github.com/dask/dask-ml/issues/1003
      "tests/model_selection/test_incremental.py"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # RuntimeError: Not enough arguments provided: missing keys
      "tests/model_selection/test_hyperband.py"
      "tests/model_selection/test_incremental.py"
      "tests/model_selection/test_incremental_warns.py"
      "tests/model_selection/test_successive_halving.py"
    ];

  disabledTests = [
    # Flaky: `Arrays are not almost equal to 3 decimals` (although values do actually match)
    "test_whitening"

    # Tests fail with dask>=0.11.2
    # RuntimeError: Not enough arguments provided
    # Reported in https://github.com/dask/dask-ml/issues/1003
    "test_basic"
    "test_hyperband_patience"
    "test_same_random_state_same_params"
    "test_search_patience_infeasible_tol"
    "test_sha_max_iter_and_metadata"
    "test_warns_decay_rate"
    "test_warns_decay_rate_wanted"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Scalable Machine Learn with Dask";
    homepage = "https://github.com/dask/dask-ml";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
