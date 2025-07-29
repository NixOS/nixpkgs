{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  setuptools,
  pytestCheckHook,
  scipy,
  numpy,
  scikit-learn,
  pandas,
  matplotlib,
  joblib,
}:

buildPythonPackage rec {
  pname = "mlxtend";
  version = "0.23.4";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = "mlxtend";
    tag = "v${version}";
    hash = "sha256-xoAHYRmqN5SrEWlc18ntTZ6WAznBlVZdf+x5Yev3ysE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    scipy
    numpy
    scikit-learn
    pandas
    matplotlib
    joblib
  ];

  patches = [
    # https://github.com/rasbt/mlxtend/issues/1117
    ./0001-StackingCVClassifier-fit-ensure-compatibility-with-s.patch
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [ "-sv" ];

  disabledTests = [
    # Type changed in numpy2 test should be updated
    "test_invalid_labels_1"
    "test_default"
    "test_nullability"
  ];

  disabledTestPaths = [
    "mlxtend/evaluate/f_test.py" # need clean
    "mlxtend/evaluate/tests/test_feature_importance.py" # urlopen error
    "mlxtend/evaluate/tests/test_bias_variance_decomp.py" # keras.api._v2
    "mlxtend/evaluate/tests/test_bootstrap_point632.py" # keras.api._v2
    # Failing tests, most likely an upstream issue. See https://github.com/rasbt/mlxtend/issues/1117
    "mlxtend/classifier/tests/test_ensemble_vote_classifier.py"
    "mlxtend/classifier/tests/test_stacking_classifier.py"
    "mlxtend/classifier/tests/test_stacking_cv_classifier.py"
  ];

  meta = {
    description = "Library of Python tools and extensions for data science";
    homepage = "https://github.com/rasbt/mlxtend";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ evax ];
    platforms = lib.platforms.unix;
  };
}
