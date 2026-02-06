{
  blas,
  cmake,
  config,
  cudaPackages,
  enableAccelerate ? false, # Use Accelerate on Darwin
  enableCuda ? config.cudaSupport,
  enableStatic ? stdenv.hostPlatform.isStatic,
  fetchFromGitHub,
  fixDarwinDylibNames,
  gfortran,
  gmp,
  lapack,
  lib,
  mpfr,
  ninja,
  openmp ? null,
  pkg-config,
  stdenv,
  writableTmpDirAsHomeHook,
}@inputs:

let
  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if enableCuda then cudaPackages.backendStdenv else inputs.stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDep = true;

  pname = "suitesparse";
  version = "7.12.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "SuiteSparse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6EMPEH5dcNT1qtuSlzR26RhpfN7MbYJdSKcrsQ0Pzow=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    # Needs to create directories as part of the build for the JIT
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals effectiveStdenv.cc.isGNU [
    # Per SuiteSparse, we can only use Fortran when it has the same compiler ID as the C/C++ compilers.
    gfortran
  ]
  ++ lib.optionals effectiveStdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_nvcc
  ];

  # Use compatible indexing for lapack and blas used
  buildInputs =
    assert (blas.isILP64 == lapack.isILP64);
    [
      blas
      lapack
      gmp
      mpfr
    ]
    ++ lib.optionals effectiveStdenv.cc.isClang [
      openmp
    ]
    ++ lib.optionals enableCuda [
      cudaPackages.cuda_cccl
      cudaPackages.cuda_cudart
      cudaPackages.cuda_nvrtc
      cudaPackages.libcublas
    ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_STATIC_LIBS" enableStatic)
    (lib.cmakeBool "SUITESPARSE_DEMOS" false) # Demos aren't installed but could make interesting unit tests
    (lib.cmakeBool "SUITESPARSE_USE_STRICT" true)
    (lib.cmakeBool "SUITESPARSE_USE_PYTHON" false)
    (lib.cmakeBool "SUITESPARSE_USE_CUDA" enableCuda)
    (lib.cmakeBool "SUITESPARSE_USE_64BIT_BLAS" blas.isILP64)
    # CMake Warning at SuiteSparse_config/cmake_modules/SuiteSparsePolicy.cmake:328 (message):
    #   Warning: Using Fortran with SuiteSparse requires that it has the same
    #   compiler ID as the C/C++ compilers.  Use a compatible Fortran compiler, or
    #   set SUITESPARSE_USE_FORTRAN to OFF.
    (lib.cmakeBool "SUITESPARSE_USE_FORTRAN" effectiveStdenv.cc.isGNU)
  ]
  ++ lib.optionals enableCuda [
    (lib.cmakeFeature "SUITESPARSE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
  ]
  ++ lib.optionals effectiveStdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "BLA_VENDOR" (if enableAccelerate then "Apple" else "Generic"))
  ];

  # Follow Spack's practice of enabling backwards compatiblity by creating symlinks to headers
  # found in the nested include/suitesparse directory at the root of include:
  # https://github.com/spack/spack-packages/blob/9a7f32a93e4096ca0747ac19a10f77f9d2762786/repos/spack_repo/builtin/packages/suite_sparse/package.py#L324-L332
  postInstall = ''
    nixLog "creating symlinks in ''${!outputDev:?}/include for backwards compat"
    pushd "''${!outputDev:?}/include" >/dev/null
    ln -svrf suitesparse/* .
    popd >/dev/null
  '';

  # The numerical tests can be flaky depending on the hardware and require further inspection before being enabled.
  doCheck = false;

  env = lib.optionalAttrs effectiveStdenv.hostPlatform.isDarwin {
    # Ensure that there is enough space for the `fixDarwinDylibNames` hook to
    # update the install names of the output dylibs.
    NIX_CFLAGS_LINK = "-headerpad_max_install_names";
  };

  meta = {
    homepage = "http://faculty.cse.tamu.edu/davis/suitesparse.html";
    description = "Suite of sparse matrix algorithms";
    license = with lib.licenses; [
      bsd2
      gpl2Plus
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ ttuegel ];
    platforms = with lib.platforms; unix;
    broken = !(enableAccelerate -> effectiveStdenv.hostPlatform.isDarwin);
  };
})
