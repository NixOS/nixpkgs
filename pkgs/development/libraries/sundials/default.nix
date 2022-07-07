{ lib, stdenv
, cmake
, fetchurl
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
  version = "6.2.0";

  outputs = [ "out" "examples" ];

  src = fetchurl {
    url = "https://github.com/LLNL/sundials/releases/download/v${version}/sundials-${version}.tar.gz";
    hash = "sha256-GV1Vk3cvxIP2Pwh5TXnkurMMLsWObOSw+2vMDgxI8x0=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs = [
    python
  ]
    ++ lib.optionals (lapackSupport)
    # Check that the same index size is used for both libraries
    (assert (blas.isILP64 == lapack.isILP64); [
      blas
      lapack
    ])
  # KLU support is based on Suitesparse. It is tested upstream according to the
  # section 1.1.4.2 of INSTALL_GUIDE.pdf found in the source tarball.
  ++ lib.optionals (kluSupport) [
    suitesparse
  ];

  cmakeFlags = [
    "-DEXAMPLES_INSTALL_PATH=${placeholder "examples"}/share/examples"
  ] ++ lib.optionals (lapackSupport) [
    "-DENABLE_LAPACK=ON"
    "-DLAPACK_LIBRARIES=${lapack}/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary}"
  ] ++ lib.optionals (kluSupport) [
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

  # disable stackprotector on aarch64-darwin for now
  # https://github.com/NixOS/nixpkgs/issues/127608
  #
  # build error:
  #
  # /private/tmp/nix-build-sundials-6.2.0.drv-0/ccD2dUtR.s:21:15: error: index must be an integer in range [-256, 255].
  #         ldr     x0, [x0, ___stack_chk_guard];momd
  #                          ^
  # /private/tmp/nix-build-sundials-6.2.0.drv-0/ccD2dUtR.s:46:15: error: index must be an integer in range [-256, 255].
  #         ldr     x0, [x0, ___stack_chk_guard];momd
  #
  # See also a proposed solution: https://github.com/NixOS/nixpkgs/pull/151983

  hardeningDisable = lib.optionals (stdenv.isAarch64 && stdenv.isDarwin) [ "stackprotector" ];

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    description = "Suite of nonlinear differential/algebraic equation solvers";
    homepage    = "https://computing.llnl.gov/projects/sundials";
    platforms   = platforms.all;
    maintainers = with maintainers; [ idontgetoutmuch ];
    license     = licenses.bsd3;
  };
}
