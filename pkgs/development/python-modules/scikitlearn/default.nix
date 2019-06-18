{ stdenv, buildPythonPackage, fetchPypi, python
, gfortran, glibcLocales, joblib, pythonOlder
, numpy, scipy, pytest, pillow, cython
}:

buildPythonPackage rec {
  pname = "scikit-learn";
  version = "0.21.2";
  # UnboundLocalError: local variable 'message' referenced before assignment
  disabled = stdenv.isi686 || (pythonOlder "3.5");  # https://github.com/scikit-learn/scikit-learn/issues/5534

  src = fetchPypi {
    inherit pname version;
    sha256 = "0aafc312a55ebf58073151b9308761a5fcfa45b7f7730cea4b1f066f824c72db";
  };

  buildInputs = [ pillow gfortran glibcLocales ];
  propagatedBuildInputs = [ numpy scipy numpy.blas joblib ];
  checkInputs = [ pytest ];
  nativeBuildInputs = [ cython ];

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
