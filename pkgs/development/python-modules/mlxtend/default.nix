{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, joblib
, keras
, matplotlib
, numpy
, pandas
, scikit-learn
, scipy
, tensorflow
}:

buildPythonPackage rec {
  pname = "mlxtend";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "rasbt";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-7G4tIoQGS7/YPpAhUn0CRf8fl/DdjdqySPWgJEL0trA=";
  };

  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "-sv" ];
  disabledTestPaths = [
    # tests download files over the network
    "mlxtend/image"
    "mlxtend/evaluate/tests/test_feature_importance.py"
    # tests that import deprecated sklearn datasets
    "mlxtend/evaluate/f_test.py"
    "mlxtend/feature_selection/tests/test_column_selector.py"
    "mlxtend/feature_selection/tests/test_exhaustive_feature_selector.py"
    "mlxtend/feature_selection/tests/test_sequential_feature_selector.py"
    "mlxtend/feature_selection/tests/test_sequential_feature_selector_feature_groups.py"
  ];
  disabledTests = [
    # Fixed in master, but failing in release version
    # see: https://github.com/rasbt/mlxtend/pull/721
    "test_variance_explained_ratio"

    # Unmaintained - TypeError: LinearRegression.__init__() got an unexpected keyword argument 'normalize'
    "test_sparsedataframe_notzero_column"
    "test_multivariate_class"
  ];

  propagatedBuildInputs = [
    joblib
    matplotlib
    numpy
    pandas
    scikit-learn
    scipy
  ];

  checkInputs = [
    keras
    tensorflow
  ];

  meta = with lib; {
    description = "A library of Python tools and extensions for data science";
    homepage = "https://github.com/rasbt/mlxtend";
    license = licenses.bsd3;
    maintainers = with maintainers; [ evax ];
    platforms = platforms.unix;
  };
}
