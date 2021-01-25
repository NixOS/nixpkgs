{ lib, buildPythonPackage, fetchPypi, isPy27
, pandas
, pytestCheckHook
, scikitlearn
, tensorflow
}:

buildPythonPackage rec {
  pname = "imbalanced-learn";
  version = "0.7.0";
  disabled = isPy27; # scikit-learn>=0.21 doesn't work on python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "da59de0d1c0fa66f62054dd9a0a295a182563aa1abbb3bf9224a3678fcfe8fa4";
  };

  propagatedBuildInputs = [ scikitlearn ];
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
  ];

  meta = with lib; {
    description = "Library offering a number of re-sampling techniques commonly used in datasets showing strong between-class imbalance";
    homepage = "https://github.com/scikit-learn-contrib/imbalanced-learn";
    license = licenses.mit;
  };
}
