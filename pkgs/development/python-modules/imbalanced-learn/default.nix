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
  version = "0.8.1";
  disabled = isPy27; # scikit-learn>=0.21 doesn't work on python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "eaf576b1ba3523a0facf3aaa483ca17e326301e53e7678c54d73b7e0250edd43";
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
