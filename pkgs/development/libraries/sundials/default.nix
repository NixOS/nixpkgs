{ stdenv
, cmake
, fetchurl
, python
, openblas
, gfortran
, lapackSupport ? true }:

let openblas32 = openblas.override { blas64 = false; };

in stdenv.mkDerivation rec {
  pname = "sundials";
  version = "5.0.0";

  buildInputs = [ python ] ++ stdenv.lib.optionals (lapackSupport) [ gfortran openblas32 ];
  nativeBuildInputs = [ cmake ];

  src = fetchurl {
    url = "https://computation.llnl.gov/projects/${pname}/download/${pname}-${version}.tar.gz";
    sha256 = "1lvx5pddjxgyr8kqlira36kxckz7nxwc8xilzfyx0hf607n42l9l";
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
  ];

  cmakeFlags = [
    "-DEXAMPLES_INSTALL_PATH=${placeholder "out"}/share/examples"
  ] ++ stdenv.lib.optionals (lapackSupport) [
    "-DSUNDIALS_INDEX_TYPE=int32_t"
    "-DLAPACK_ENABLE=ON"
    "-DLAPACK_LIBRARIES=${openblas32}/lib/libopenblas${stdenv.hostPlatform.extensions.sharedLibrary}"
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
