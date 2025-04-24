{
  lib,
  stdenv,
  cmake,
  fetchurl,
  python,
  blas,
  lapack,
  gfortran,
  suitesparse,
  lapackSupport ? true,
  kluSupport ? true,
}:

stdenv.mkDerivation rec {
  pname = "sundials";
  version = "7.2.0";

  outputs = [
    "out"
    "examples"
  ];

  src = fetchurl {
    url = "https://github.com/LLNL/sundials/releases/download/v${version}/sundials-${version}.tar.gz";
    hash = "sha256-XGwKZqfifEW/tXsn91eUY4Vahfw5dv7R1cndiNwa46s=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs =
    [
      python
    ]
    ++
      lib.optionals (lapackSupport)
        # Check that the same index size is used for both libraries
        (
          assert (blas.isILP64 == lapack.isILP64);
          [
            blas
            lapack
          ]
        )
    # KLU support is based on Suitesparse. It is tested upstream according to the
    # section 1.1.4.2 of INSTALL_GUIDE.pdf found in the source tarball.
    ++ lib.optionals (kluSupport) [
      suitesparse
    ];

  cmakeFlags =
    [
      "-DEXAMPLES_INSTALL_PATH=${placeholder "examples"}/share/examples"
    ]
    ++ lib.optionals (lapackSupport) [
      "-DENABLE_LAPACK=ON"
      "-DLAPACK_LIBRARIES=${lapack}/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary}"
    ]
    ++ lib.optionals (kluSupport) [
      "-DENABLE_KLU=ON"
      "-DKLU_INCLUDE_DIR=${suitesparse.dev}/include"
      "-DKLU_LIBRARY_DIR=${suitesparse}/lib"
    ]
    ++ [
      (
        # Use the correct index type according to lapack and blas used. They are
        # already supposed to be compatible but we check both for extra safety. 64
        # should be the default but we prefer to be explicit, for extra safety.
        if blas.isILP64 then "-DSUNDIALS_INDEX_SIZE=64" else "-DSUNDIALS_INDEX_SIZE=32"
      )
    ];

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    description = "Suite of nonlinear differential/algebraic equation solvers";
    homepage = "https://computing.llnl.gov/projects/sundials";
    platforms = platforms.all;
    maintainers = with maintainers; [ idontgetoutmuch ];
    license = licenses.bsd3;
  };
}
