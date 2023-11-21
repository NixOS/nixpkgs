{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, importlib-metadata
, joblib
, llvmlite
, numba
, scikit-learn
, scipy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynndescent";
  version = "0.5.10";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XV3Gg8A+9V/j3faThZcgyhj4XG5uW7C08UhwJ41SiK0=";
  };

  patches = [
    # https://github.com/lmcinnes/pynndescent/pull/224
    (fetchpatch {
      url = "https://github.com/lmcinnes/pynndescent/commit/86e0d716a3a4d5f4e6a0a3c2952f6fe339524e96.patch";
      hash = "sha256-dfnT5P9Qsn/nSAr4Ysqo/olbLLfoZXvBRz33yzhN3J4=";
    })
  ];

  propagatedBuildInputs = [
    joblib
    llvmlite
    numba
    scikit-learn
    scipy
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # numpy.core._exceptions._UFuncNoLoopError
    "test_sparse_nn_descent_query_accuracy_angular"
    "test_nn_descent_query_accuracy_angular"
    "test_alternative_distances"
    # scipy: ValueError: Unknown Distance Metric: wminkowski
    # https://github.com/scikit-learn/scikit-learn/pull/21741
    "test_weighted_minkowski"
  ];

  pythonImportsCheck = [
    "pynndescent"
  ];

  meta = with lib; {
    description = "Nearest Neighbor Descent";
    homepage = "https://github.com/lmcinnes/pynndescent";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mic92 ];
  };
}
