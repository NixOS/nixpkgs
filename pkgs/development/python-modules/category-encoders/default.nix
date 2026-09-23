{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  setuptools,

  # dependencies
  importlib-resources,
  numpy,
  pandas,
  patsy,
  scikit-learn,
  scipy,
  statsmodels,

  # test
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "category-encoders";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scikit-learn-contrib";
    repo = "category_encoders";
    tag = version;
    hash = "sha256-OcQCEWxqH6b9adQk64fdnqFl5CGLb9Yyd7bSxSaGTvg=";
  };

  build-system = [
    poetry-core
    setuptools
  ];

  dependencies = [
    importlib-resources
    numpy
    pandas
    patsy
    scikit-learn
    scipy
    statsmodels
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: Lists differ: [0.5, 0.5, 0.25, 0.5, 0.75, nan, nan, nan] !=...
    "test_cat_boost_missing"
    # AssertionError: False is not true
    "test_ignored_columns_are_untouched"
    # AssertionError: DataFrame.iloc[:, 0] (column name="0") are different
    "test_missing_values"
    # sklearn.exceptions.NotFittedError: Estimator has to be fitted to return featureS...
    "test_feature_names_out"
    "test_hierarchy_with_scikit_learn_column_transformer"
    "test_sklearn_pandas_out_refit"
    # AssertionError
    "test_unknown_value"

  ];

  pythonImportsCheck = [
    "category_encoders"
  ];

  meta = {
    description = "Library for sklearn compatible categorical variable encoders";
    homepage = "https://github.com/scikit-learn-contrib/category_encoders";
    changelog = "https://github.com/scikit-learn-contrib/category_encoders/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
}
