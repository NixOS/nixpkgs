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
  version = "4.1.0";

  buildInputs = [ python ] ++ stdenv.lib.optionals (lapackSupport) [ gfortran ];
  nativeBuildInputs = [ cmake ];

  src = fetchurl {
    url = "https://computation.llnl.gov/projects/${pname}/download/${pname}-${version}.tar.gz";
    sha256 = "19ca4nmlf6i9ijqcibyvpprxzsdfnackgjs6dw51fq13gg1f2398";
  };

  patches = [
    (fetchurl {
      # https://github.com/LLNL/sundials/pull/19
      url = "https://github.com/LLNL/sundials/commit/1350421eab6c5ab479de5eccf6af2dcad1eddf30.patch";
      sha256 = "0g67lixp9m85fqpb9rzz1hl1z8ibdg0ldwq5z6flj5zl8a7cw52l";
    })
    (fetchurl {
      # https://github.com/LLNL/sundials/pull/20
      url = "https://github.com/LLNL/sundials/pull/20/commits/2d951bbe1ff7842fcd0dafa28c61b0aa94015f66.patch";
      sha256 = "0lcr6m4lk14yqrxah4rdscpczny5l7m1zpfsjh8bgspadfsgk512";
    })
    # https://github.com/LLNL/sundials/pull/21
    ./tests-parallel.patch
  ];

  cmakeFlags = [
    "-DEXAMPLES_INSTALL_PATH=${placeholder "out"}/share/examples"
  ] ++ stdenv.lib.optionals (lapackSupport) [
    "-DSUNDIALS_INDEX_TYPE=int32_t"
    "-DLAPACK_ENABLE=ON"
    "-DLAPACK_LIBRARIES=${liblapackShared}/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary};${liblapackShared}/lib/libblas${stdenv.hostPlatform.extensions.sharedLibrary}"
  ];

  doCheck = true;
  checkPhase = "make test";

  meta = with stdenv.lib; {
    description = "Suite of nonlinear differential/algebraic equation solvers";
    homepage    = https://computation.llnl.gov/projects/sundials;
    platforms   = platforms.all;
    maintainers = with maintainers; [ flokli idontgetoutmuch ];
    license     = licenses.bsd3;
  };
}
