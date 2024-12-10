{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  setuptools-scm,
  dask,
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
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dask-ml";
  version = "2024.4.4";
  pyproject = true;

  disabled = pythonOlder "3.6";

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

  disabledTestPaths = [
    # AttributeError: 'csr_matrix' object has no attribute 'A'
    # Fixed in https://github.com/dask/dask-ml/pull/996
    "tests/test_svd.py"
  ];

  disabledTests = [
    # Flaky: `Arrays are not almost equal to 3 decimals` (although values do actually match)
    "test_whitening"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Scalable Machine Learn with Dask";
    homepage = "https://github.com/dask/dask-ml";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
