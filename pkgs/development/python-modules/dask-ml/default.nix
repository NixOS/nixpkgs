{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
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
  version = "2025.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dask";
    repo = "dask-ml";
    tag = "v${version}";
    hash = "sha256-DHxx0LFuJmGWYuG/WGHj+a5XHAEekBmlHUUb90rl2IY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'addopts = "-rsx -v --durations=10 --color=yes"' \
                     'addopts = ["-rsx", "-v", "--durations=10", "--color=yes"]'
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
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

  disabledTestPaths = [
    # RuntimeError: Attempting to use an asynchronous Client in a synchronous context of `dask.compute`
    # https://github.com/dask/dask-ml/issues/1016
    "tests/model_selection/test_hyperband.py"
    "tests/model_selection/test_incremental.py"
    "tests/model_selection/test_incremental_warns.py"
    "tests/model_selection/test_successive_halving.py"

    # MockClassifier predates sklearn 1.6 __sklearn_tags__
    "tests/model_selection/dask_searchcv/test_model_selection.py"
    "tests/model_selection/dask_searchcv/test_model_selection_sklearn.py"
  ];

  disabledTests = [
    # AssertionError: Regex pattern did not match.
    "test_unknown_category_transform_array"

    # ValueError: cannot broadcast shape (nan,) to shape (nan,)
    # https://github.com/dask/dask-ml/issues/1012
    "test_fit_array"
    "test_fit_frame"
    "test_fit_transform_frame"
    "test_laziness"
    "test_lr_score"
    "test_ok"
    "test_scoring_string"

    # sklearn 1.7+: PCA / IncrementalPCA missing power_iteration_normalizer
    "test_pca_randomized_solver"
    "test_pca_check_projection"
    "test_pca_inverse"
    "test_pca_score"
    "test_pca_score2"
    "test_randomized_pca_check_projection"
    "test_randomized_pca_inverse"
    "test_pca_int_dtype_upcast_to_double"
    "test_incremental_pca"
    "test_incremental_pca_against_pca_iris"
    "test_incremental_pca_against_pca_random_data"
    "test_singular_values"
    "test_whitening"

    # sklearn 1.8 API drift in LogisticRegression/ParallelPostFit
    "test_predict"
    "test_multiclass"

    # XPASS becomes failure under xfail_strict (now honored on pytest 9)
    "test_soft_voting_frame"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Scalable Machine Learn with Dask";
    homepage = "https://github.com/dask/dask-ml";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
