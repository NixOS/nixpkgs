{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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

  dependencies =
    [
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
    # AttributeError: module 'numpy' has no attribute 'product'
    "tests/test_svd.py"
  ];

  disabledTests = [
    # AssertionError: Regex pattern did not match.
    "test_unknown_category_transform_array"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Scalable Machine Learn with Dask";
    homepage = "https://github.com/dask/dask-ml";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
