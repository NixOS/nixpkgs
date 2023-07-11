{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, pandas
, pytestCheckHook
, scikit-learn
}:

buildPythonPackage rec {
  pname = "imbalanced-learn";
  version = "0.10.1";
  disabled = isPy27; # scikit-learn>=0.21 doesn't work on python2

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vHYJYZ7Dw4xEIpKSgjmtPRC13rCviinIOCK3tXsxn4s=";
  };

  propagatedBuildInputs = [ scikit-learn ];
  nativeCheckInputs = [ pytestCheckHook pandas ];
  preCheck = ''
    export HOME=$TMPDIR
  '';
  disabledTests = [
    "estimator"
    "classification"
    "_generator"
    "show_versions"
    "test_make_imbalanced_iris"
    "test_rusboost[SAMME.R]"

    # https://github.com/scikit-learn-contrib/imbalanced-learn/issues/824
    "ValueDifferenceMetric"
  ];

  meta = with lib; {
    description = "Library offering a number of re-sampling techniques commonly used in datasets showing strong between-class imbalance";
    homepage = "https://github.com/scikit-learn-contrib/imbalanced-learn";
    license = licenses.mit;
    maintainers = [ maintainers.rmcgibbo ];
  };
}
