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
  version = "0.9.0";
  disabled = isPy27; # scikit-learn>=0.21 doesn't work on python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "836a4c137cc3c10310d4f6cd5ec34600ff488d7f8c243a997c3f9b551c91d0b2";
  };

  propagatedBuildInputs = [ scikit-learn ];
  checkInputs = [ pytestCheckHook pandas ];
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
