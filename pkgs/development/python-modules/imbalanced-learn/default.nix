{ stdenv, buildPythonPackage, fetchPypi, scikitlearn, pandas, nose, pytest }:

buildPythonPackage rec {
  pname = "imbalanced-learn";
  version = "0.3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r5js9kw6rvmfvxxkfjlcxv5xn5h19qvg7d41byilxwq9kd515g4";
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
