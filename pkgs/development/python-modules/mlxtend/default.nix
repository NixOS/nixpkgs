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
  version = "0.24.0";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = "mlxtend";
    tag = "v${version}";
    hash = "sha256-zDMFfm8VqEfAQd11PZNp7HsoLcqrj3nMqnvKhXaeA04=";
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

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [ "-sv" ];

  disabledTests = [
    # Type changed in numpy2 test should be updated
    "test_invalid_labels_1"
    "test_default"
    "test_nullability"
    # see upstream issue https://github.com/rasbt/mlxtend/issues/1161
    # skip the "TypeError: only 0-dimensional arrays can be converted to Python scalars" failures in test_perceptron
    "test_standardized_iris_data"
    "test_progress_1"
    "test_progress_2"
    "test_progress_3"
    "test_score_function"
    "test_nonstandardized_iris_data"
  ];

  disabledTestPaths = [
    "mlxtend/evaluate/f_test.py" # need clean
    "mlxtend/evaluate/tests/test_feature_importance.py" # urlopen error
    "mlxtend/evaluate/tests/test_bias_variance_decomp.py" # keras.api._v2
    "mlxtend/evaluate/tests/test_bootstrap_point632.py" # keras.api._v2
  ];

  meta = {
    description = "Library of Python tools and extensions for data science";
    homepage = "https://github.com/rasbt/mlxtend";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ evax ];
    platforms = lib.platforms.unix;
  };
}
