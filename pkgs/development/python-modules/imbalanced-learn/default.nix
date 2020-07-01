{ stdenv, buildPythonPackage, fetchPypi, isPy27
, nose
, pandas
, pytest
, scikitlearn
, tensorflow
}:

buildPythonPackage rec {
  pname = "imbalanced-learn";
  version = "0.6.2";
  disabled = isPy27; # scikit-learn>=0.21 doesn't work on python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "942b9a7f2e1df831097fbee587c5c90a4cc6afa6105b23d3e30d8798f1a9b17d";
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
    description = "Library offering a number of re-sampling techniques commonly used in datasets showing strong between-class imbalance";
    homepage = "https://github.com/scikit-learn-contrib/imbalanced-learn";
    license = licenses.mit;
  };
}
