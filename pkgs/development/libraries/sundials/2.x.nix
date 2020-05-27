{ stdenv
, cmake
, fetchurl
, python
# GNU Octave needs KLU for ODE solvers
, suitesparse
, blas, lapack
, gfortran
, lapackSupport ? true }:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "sundials";
  version = "2.7.0";

  buildInputs = [ python ] ++ stdenv.lib.optionals (lapackSupport) [
    gfortran
    suitesparse
  ];
  nativeBuildInputs = [ cmake ];

  src = fetchurl {
    url = "https://computation.llnl.gov/projects/${pname}/download/${pname}-${version}.tar.gz";
    sha256 = "01513g0j7nr3rh7hqjld6mw0mcx5j9z9y87bwjc16w2x2z3wm7yk";
  };

  patches = [
    (fetchurl {
      # https://github.com/LLNL/sundials/pull/19
      url = "https://github.com/LLNL/sundials/commit/1350421eab6c5ab479de5eccf6af2dcad1eddf30.patch";
      sha256 = "0g67lixp9m85fqpb9rzz1hl1z8ibdg0ldwq5z6flj5zl8a7cw52l";
    })
  ];

  cmakeFlags = [
    "-DEXAMPLES_INSTALL_PATH=${placeholder "out"}/share/examples"
  ] ++ stdenv.lib.optionals (lapackSupport) [
    "-DSUNDIALS_INDEX_TYPE=int32_t"
    # GNU Octave needs KLU for ODE solvers
    "-DKLU_ENABLE=ON"
    "-DKLU_INCLUDE_DIR=${suitesparse}/include"
    "-DKLU_LIBRARY_DIR=${suitesparse}/lib"
    "-DLAPACK_ENABLE=ON"
    "-DLAPACK_LIBRARIES=${lapack}/lib/lapack${stdenv.hostPlatform.extensions.sharedLibrary};${blas}/lib/blas${stdenv.hostPlatform.extensions.sharedLibrary}"
  ];

  # flaky tests, and patch in https://github.com/LLNL/sundials/pull/21 doesn't apply cleanly for sundials_3
  doCheck = false;
  checkPhase = "make test";

  meta = with stdenv.lib; {
    description = "Suite of nonlinear differential/algebraic equation solvers";
    homepage    = "https://computation.llnl.gov/projects/sundials";
    platforms   = platforms.all;
    maintainers = with maintainers; [ flokli idontgetoutmuch ];
    license     = licenses.bsd3;
  };
}
