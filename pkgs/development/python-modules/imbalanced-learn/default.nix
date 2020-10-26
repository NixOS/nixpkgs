{ stdenv, buildPythonPackage, fetchPypi, isPy27
, nose
, pandas
, pytest
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
  checkInputs = [ nose pytest pandas ];
  checkPhase = ''
    export HOME=$TMPDIR
    # skip some tests that fail because of minimal rounding errors
    # or very large dependencies (keras + tensorflow)
    py.test imblearn -k 'not estimator \
                         and not classification \
                         and not _generator \
                         and not show_versions'
  '';

  meta = with stdenv.lib; {
    broken = true;
    description = "Library offering a number of re-sampling techniques commonly used in datasets showing strong between-class imbalance";
    homepage = "https://github.com/scikit-learn-contrib/imbalanced-learn";
    license = licenses.mit;
  };
}
