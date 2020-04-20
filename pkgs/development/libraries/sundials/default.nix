{ stdenv
, cmake
, fetchurl
, python
, blas
, lapack
, gfortran
, lapackSupport ? true }:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "sundials";
  version = "5.1.0";

  buildInputs = [ python ] ++ stdenv.lib.optionals (lapackSupport) [ gfortran blas lapack ];
  nativeBuildInputs = [ cmake ];

  src = fetchurl {
    url = "https://computation.llnl.gov/projects/${pname}/download/${pname}-${version}.tar.gz";
    sha256 = "08cvzmbr2qc09ayq4f5j07lw97hl06q4dl26vh4kh822mm7x28pv";
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
    "-DLAPACK_ENABLE=ON"
    "-DLAPACK_LIBRARIES=${lapack}/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary}"
  ];

  doCheck = true;
  checkPhase = "make test";

  meta = with stdenv.lib; {
    description = "Suite of nonlinear differential/algebraic equation solvers";
    homepage    = "https://computation.llnl.gov/projects/sundials";
    platforms   = platforms.all;
    maintainers = with maintainers; [ flokli idontgetoutmuch ];
    license     = licenses.bsd3;
  };
}
