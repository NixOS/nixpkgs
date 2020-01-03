{ stdenv
, cmake
, fetchurl
, python
, liblapack
, gfortran
, lapackSupport ? true }:

let liblapackShared = liblapack.override {
  shared = true;
};

in stdenv.mkDerivation rec {
  pname = "sundials";
  version = "3.2.1";

  buildInputs = [ python ] ++ stdenv.lib.optionals (lapackSupport) [ gfortran ];
  nativeBuildInputs = [ cmake ];

  src = fetchurl {
    url = "https://computation.llnl.gov/projects/${pname}/download/${pname}-${version}.tar.gz";
    sha256 = "0238r1qnwqz13wcjzfsbcfi8rfnlxcjjmxq2vpf2qf5jgablvna7";
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
    "-DLAPACK_LIBRARIES=${liblapackShared}/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary};${liblapackShared}/lib/libblas${stdenv.hostPlatform.extensions.sharedLibrary}"
  ];

  # flaky tests, and patch in https://github.com/LLNL/sundials/pull/21 doesn't apply cleanly for sundials_3
  doCheck = false;
  checkPhase = "make test";

  meta = with stdenv.lib; {
    description = "Suite of nonlinear differential/algebraic equation solvers";
    homepage    = https://computation.llnl.gov/projects/sundials;
    platforms   = platforms.all;
    maintainers = with maintainers; [ flokli idontgetoutmuch ];
    license     = licenses.bsd3;
  };
}
