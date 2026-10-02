{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "0.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = "mlxtend";
    tag = "v${version}";
    hash = "sha256-h0qGvQfsWOCP/9XPlih94nGNp4ppplWJ+89qedYipPk=";
  };

  patches = [
    # Fixes tests after upgrading scikit-learn 1.8.0->1.9.0
    # Remove on next release https://github.com/rasbt/mlxtend/commit/93ac19f44b8e9688ea76459bb523a964a1dab2b6
    ./fix-sklearn-1.9-tests.patch
  ];

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
