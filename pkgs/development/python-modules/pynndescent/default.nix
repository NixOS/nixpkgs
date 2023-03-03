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
  version = "0.5.8";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-p8VSVpv2BKEB/VS7odJ8EjieBllF3uOmd3pRjGOkbys=";
  };

  patches = [
    # Fix sklearn 1.2.0 compat; https://github.com/lmcinnes/pynndescent/issues/207
    (fetchpatch {
      url = "https://github.com/lmcinnes/pynndescent/commit/00444be2107b71169b853847e7b334623c58a4e3.patch";
      hash = "sha256-mbe01BwroS5q6hENsj3NejmGGhmk2IeX4LD6Iq6PR0c=";
    })
    (fetchpatch {
      url = "https://github.com/lmcinnes/pynndescent/commit/e56b92776a4a05f2dabb80d25479bd37e7ebd88e.patch";
      hash = "sha256-zVTaW4syGEHh2HAGPyBN3YXqUGe55v/LxKLX/zjXT5Y=";
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
