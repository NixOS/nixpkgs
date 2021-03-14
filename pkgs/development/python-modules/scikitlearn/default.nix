{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, gfortran
, glibcLocales
, numpy
, scipy
, pytest
, pillow
, cython
, joblib
, llvmPackages
, threadpoolctl
, pythonOlder
}:

buildPythonPackage rec {
  pname = "scikit-learn";
  version = "0.24.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "oDNKGALmTWVgIsO/q1anP71r9LEpg0PzaIryFRgQu98=";
  };

  patches = [
    # This patch fixes compatibility with numpy 1.20. It was merged before 0.24.1 was released,
    # but for some reason was not included in the 0.24.1 release tarball.
    (fetchpatch {
      url = "https://github.com/scikit-learn/scikit-learn/commit/e7ef22c3ba2334cb3b476e95d7c083cf6b48ce56.patch";
      sha256 = "174554k1pbf92bj7wgq0xjj16bkib32ailyhwavdxaknh4bd9nmv";
    })
  ];

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
    threadpoolctl
  ];
  checkInputs = [ pytest ];

  LC_ALL="en_US.UTF-8";

  doCheck = !stdenv.isAarch64;
  # Skip test_feature_importance_regression - does web fetch
  checkPhase = ''
    cd $TMPDIR
    HOME=$TMPDIR OMP_NUM_THREADS=1 pytest -k "not test_feature_importance_regression" --pyargs sklearn
  '';

  meta = with lib; {
    description = "A set of python modules for machine learning and data mining";
    changelog = let
      major = versions.major version;
      minor = versions.minor version;
      dashVer = replaceChars ["."] ["-"] version;
    in
      "https://scikit-learn.org/stable/whats_new/v${major}.${minor}.html#version-${dashVer}";
    homepage = "https://scikit-learn.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
