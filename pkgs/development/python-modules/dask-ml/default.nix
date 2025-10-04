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
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Scalable Machine Learn with Dask";
    homepage = "https://github.com/dask/dask-ml";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
