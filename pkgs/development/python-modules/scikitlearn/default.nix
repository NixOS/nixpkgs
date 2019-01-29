{ stdenv, buildPythonPackage, fetchPypi, python
, gfortran, glibcLocales
, numpy, scipy, pytest, pillow
}:

buildPythonPackage rec {
  pname = "scikit-learn";
  version = "0.20.2";
  # UnboundLocalError: local variable 'message' referenced before assignment
  disabled = stdenv.isi686;  # https://github.com/scikit-learn/scikit-learn/issues/5534

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ri9kx0yrn85h6ivkaja35afbyhimxn8lsairgns2wi5xv3wfnxw";
  };

  buildInputs = [ pillow gfortran glibcLocales ];
  propagatedBuildInputs = [ numpy scipy numpy.blas ];
  checkInputs = [ pytest ];

  LC_ALL="en_US.UTF-8";

  doCheck = !stdenv.isAarch64;
  # Skip test_feature_importance_regression - does web fetch
  checkPhase = ''
    cd $TMPDIR
    HOME=$TMPDIR OMP_NUM_THREADS=1 pytest -k "not test_feature_importance_regression" --pyargs sklearn
  '';

  meta = with stdenv.lib; {
    description = "A set of python modules for machine learning and data mining";
    homepage = http://scikit-learn.org;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
