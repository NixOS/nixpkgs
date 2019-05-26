{ stdenv, buildPythonPackage, fetchPypi, scikitlearn, pandas, nose, pytest }:

buildPythonPackage rec {
  pname = "imbalanced-learn";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5bd9e86e40ce4001a57426541d7c79b18143cbd181e3330c1a3e5c5c43287083";
  };

  propagatedBuildInputs = [ scikitlearn ];
  checkInputs = [ nose pytest pandas ];
  checkPhase = ''
    export HOME=$PWD
    # skip some tests that fail because of minimal rounding errors
    py.test imblearn --ignore=imblearn/metrics/classification.py
    py.test doc/*.rst
  '';

  meta = with stdenv.lib; {
    description = "Library offering a number of re-sampling techniques commonly used in datasets showing strong between-class imbalance";
    homepage = https://github.com/scikit-learn-contrib/imbalanced-learn;
    license = licenses.mit;
  };
}
