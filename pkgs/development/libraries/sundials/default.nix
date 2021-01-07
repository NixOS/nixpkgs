{ stdenv
, cmake
, fetchurl
, fetchpatch
, python
, blas
, lapack
, gfortran
, suitesparse
, lapackSupport ? true
, kluSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "sundials";
  version = "5.6.1";

  outputs = [ "out" "examples" ];

  src = fetchurl {
    url = "https://computation.llnl.gov/projects/${pname}/download/${pname}-${version}.tar.gz";
    sha256 = "Frd5mex+fyFXqh0Eyh3kojccqBUOBW0klR0MWJZvKoM=";
  };

  patches = [
    # Fixing an upstream regression in treating cmake prefix directories:
    # https://github.com/LLNL/sundials/pull/58
    (fetchpatch {
      url = "https://github.com/LLNL/sundials/commit/dd32ff9baa05618f36e44aadb420bbae4236ea1e.patch";
      sha256 = "kToAuma+2iHFyL1v/l29F3+nug4AdK5cPG6IcXv2afc=";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    python
  ]
    ++ stdenv.lib.optionals (lapackSupport)
    # Check that the same index size is used for both libraries
    (assert (blas.isILP64 == lapack.isILP64); [
      gfortran
      blas
      lapack
    ])
  # KLU support is based on Suitesparse.
  # It is tested upstream according to the section 1.1.4 of
  # [INSTALL_GUIDE.pdf](https://raw.githubusercontent.com/LLNL/sundials/master/INSTALL_GUIDE.pdf)
  ++ stdenv.lib.optionals (kluSupport) [
    suitesparse
  ];

  cmakeFlags = [
    "-DEXAMPLES_INSTALL_PATH=${placeholder "examples"}/share/examples"
  ] ++ stdenv.lib.optionals (lapackSupport) [
    "-DENABLE_LAPACK=ON"
    "-DLAPACK_LIBRARIES=${lapack}/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary}"
  ] ++ stdenv.lib.optionals (kluSupport) [
    "-DENABLE_KLU=ON"
    "-DKLU_INCLUDE_DIR=${suitesparse.dev}/include"
    "-DKLU_LIBRARY_DIR=${suitesparse}/lib"
  ] ++ [(
    # Use the correct index type according to lapack and blas used. They are
    # already supposed to be compatible but we check both for extra safety. 64
    # should be the default but we prefer to be explicit, for extra safety.
    if blas.isILP64 then
      "-DSUNDIALS_INDEX_SIZE=64"
    else
      "-DSUNDIALS_INDEX_SIZE=32"
  )]
  ;

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "Suite of nonlinear differential/algebraic equation solvers";
    homepage    = "https://computation.llnl.gov/projects/sundials";
    platforms   = platforms.all;
    maintainers = with maintainers; [ idontgetoutmuch ];
    license     = licenses.bsd3;
  };
}
