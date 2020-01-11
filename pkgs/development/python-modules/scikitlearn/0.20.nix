{ stdenv, buildPythonPackage, fetchPypi
, gfortran, glibcLocales
, numpy, scipy, pytest, pillow
}:

# 0.20.x is the last version that maintains python2 compatibility

buildPythonPackage rec {
  pname = "scikit-learn";
  version = "0.20.4";
  # UnboundLocalError: local variable 'message' referenced before assignment
  disabled = stdenv.isi686;  # https://github.com/scikit-learn/scikit-learn/issues/5534

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z3w2c50dwwa297j88pr16pyrjysagsvdj7vrlq40q8777rs7a6z";
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
