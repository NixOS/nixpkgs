{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, gfortran, glibcLocales
, numpy, scipy, pytest, pillow
, cython
, joblib
, llvmPackages
}:

buildPythonPackage rec {
  pname = "scikit-learn";
  version = "0.21.3";
  # UnboundLocalError: local variable 'message' referenced before assignment
  disabled = stdenv.isi686;  # https://github.com/scikit-learn/scikit-learn/issues/5534

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb9b8ebf59eddd8b96366428238ab27d05a19e89c5516ce294abc35cea75d003";
  };

  buildInputs = [
    pillow
    gfortran
    glibcLocales
  ] ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    numpy.blas
    joblib
  ];
  checkInputs = [ pytest ];

  patches = [
    # Fixes tests by changing threshold of a test-case that broke
    # with numpy versions >= 1.17. This should be removed for versions > 0.21.2.
	( fetchpatch {
	  url = "https://github.com/scikit-learn/scikit-learn/commit/b730befc821caec5b984d9ff3aa7bc4bd7f4d9bb.patch";
	  sha256 = "0z36m05mv6d494qwq0688rgwa7c4bbnm5s2rcjlrp29fwn3fy1bv";
	})
  ];

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
