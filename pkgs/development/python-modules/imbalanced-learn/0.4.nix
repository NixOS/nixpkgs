{ stdenv, buildPythonPackage, fetchPypi, scikitlearn, pandas, nose, pytest }:

buildPythonPackage rec {
  pname = "imbalanced-learn";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5df760537886678ef9e25f5bad96d194c5fc66f62de84488069acf5d4b0119d5";
  };

  propagatedBuildInputs = [ scikitlearn ];
  checkInputs = [ nose pytest pandas ];
  checkPhase = ''
    export HOME=$PWD
    # skip some tests that fail because of minimal rounding errors
    # or large dependencies
    py.test imblearn -k 'not classification \
                         and not _generator \
                         and not _forest \
                         and not wrong_memory'
  '';

  meta = with stdenv.lib; {
    description = "Library offering a number of re-sampling techniques commonly used in datasets showing strong between-class imbalance";
    homepage = https://github.com/scikit-learn-contrib/imbalanced-learn;
    license = licenses.mit;
  };
}
