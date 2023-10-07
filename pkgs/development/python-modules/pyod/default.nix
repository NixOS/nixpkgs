{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, fetchpatch
, joblib
, matplotlib
, numba
, numpy
, scikit-learn
, scipy
, six
, pytestCheckHook
, pandas
, torch
, statsmodels
, xgboost
}:

buildPythonPackage rec {
  pname = "pyod";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yzhao062";
    repo = "pyod";
    rev = "v${version}";
    hash = "sha256-nPFoN6Zd7kI2dVNGynidGy95n8zudpgLPGznohP7f4Q=";
  };

  patches = [
    # Fix ImportError: cannot import name 'DistanceMetric' from 'sklearn.neighbors' error
    (fetchpatch {
      name = "fix-sklearn-distancemetric.patch";
      url = "https://github.com/yzhao062/pyod/pull/513/commits/55ff0d45545da60237642d6d52d086ea4e33cd08.patch";
      sha256 = "sha256-kMSYnMvXn2rEIuNHr1GjskF25yyzEh9UrVeSW3xnb0k=";
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    joblib
    matplotlib
    numba
    numpy
    scikit-learn
    scipy
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
    torch
    statsmodels
    xgboost
    # tensorflow - uncomment when fixed
    # not in nixpkgs
    # suod
    # combo
    # pythresh
  ];

  disabledTestPaths = [
    # tensorflow required
    "pyod/test/test_alad.py"
    "pyod/test/test_anogan.py"
    "pyod/test/test_auto_encoder.py"
    "pyod/test/test_deepsvdd.py"
    "pyod/test/test_mo_gaal.py"
    "pyod/test/test_so_gaal.py"
    "pyod/test/test_vae.py"

    # combo required
    "pyod/test/test_combination.py"
    "pyod/test/test_feature_bagging.py"

    # suod required
    "pyod/test/test_suod.py"

    # pythresh required
    "pyod/test/test_thresholds.py"
  ];

  pythonImportsCheck = [ "pyod" ];

  meta = with lib; {
    description = "A Comprehensive and Scalable Python Library for Outlier Detection (Anomaly Detection";
    homepage = "https://github.com/yzhao062/pyod";
    changelog = "https://github.com/yzhao062/pyod/blob/${src.rev}/CHANGES.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
