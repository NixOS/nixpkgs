{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  setuptools-scm,
  joblib,
  keras,
  numpy,
  pandas,
  scikit-learn,
  scipy,
  tensorflow,
  threadpoolctl,
  pytestCheckHook,
  python,
}:

buildPythonPackage rec {
  pname = "imbalanced-learn";
  version = "0.14.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scikit-learn-contrib";
    repo = "imbalanced-learn";
    tag = version;
    hash = "sha256-1R7jHOkTO3zK9bkUvvOPQ420ofqIO7J1rqixFEbApR0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    joblib
    numpy
    scikit-learn
    scipy
    threadpoolctl
  ];

  optional-dependencies = {
    optional = [
      keras
      pandas
      tensorflow
    ];
  };

  pythonImportsCheck = [ "imblearn" ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
  ];

  preCheck = ''
    export HOME=$TMPDIR
    # The GitHub source contains too many files picked up by pytest like
    # examples and documentation files which can't pass.
    cd $out/${python.sitePackages}
  '';

  disabledTestPaths = [
    # require tensorflow and keras, but we don't want to
    # add them to nativeCheckInputs just for this tests
    "imblearn/keras"
    "imblearn/tensorflow"
    # even with precheck directory change, pytest still tries to test docstrings
    "imblearn/tests/test_docstring_parameters.py"
    # Skip dependencies test - pythonImportsCheck already does this
    "imblearn/utils/tests/test_min_dependencies.py"
  ];

  disabledTests = [
    # Broken upstream test https://github.com/scikit-learn-contrib/imbalanced-learn/issues/1131
    "test_estimators_compatibility_sklearn"
    "test_balanced_bagging_classifier_with_function_sampler"
  ];

  meta = {
    description = "Library offering a number of re-sampling techniques commonly used in datasets showing strong between-class imbalance";
    homepage = "https://github.com/scikit-learn-contrib/imbalanced-learn";
    changelog = "https://github.com/scikit-learn-contrib/imbalanced-learn/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      rmcgibbo
      philipwilk
    ];
  };
}
