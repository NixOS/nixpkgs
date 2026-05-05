{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  blas,
  lapack,
  metis,
  fixDarwinDylibNames,
  gmp,
  mpfr,
  config,
  enableCuda ? config.cudaSupport,
  cudaPackages,
  llvmPackages,
}@inputs:

let
  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if enableCuda then cudaPackages.backendStdenv else inputs.stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "suitesparse";
  version = "7.10.0";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "SuiteSparse";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-FcEyOvt96FLwCTil4l52ug+faiRlEG+mMUvKWipMxng=";
  };

  nativeBuildInputs = [
    cmake
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
      metis
      (lib.getLib gfortran.cc)
      gmp
      mpfr
    ]
    ++ lib.optionals effectiveStdenv.cc.isClang [
      llvmPackages.openmp
    ]
    ++ lib.optionals enableCuda [
      cudaPackages.cuda_cudart
      cudaPackages.cuda_cccl
      cudaPackages.libcublas
    ];

  preConfigure = ''
    export GRAPHBLAS_CACHE_PATH="$(mktemp -d)"
  '';

  cmakeFlags = [
    (lib.cmakeBool "SUITESPARSE_USE_PYTHON" false)
    (lib.cmakeFeature "BLAS_LIBRARIES" "${lib.getLib blas}/lib/libblas${effectiveStdenv.hostPlatform.extensions.sharedLibrary}")
    (lib.cmakeFeature "LAPACK_LIBRARIES" "${lib.getLib lapack}/lib/liblapack${effectiveStdenv.hostPlatform.extensions.sharedLibrary}")
    (lib.cmakeBool "SUITESPARSE_USE_64BIT_BLAS" blas.isILP64)
  ]
  ++ lib.optionals (effectiveStdenv.hostPlatform != effectiveStdenv.buildPlatform) [
    # GraphBLAS JIT builds a native helper binary (grb_jitpackage) but uses
    # the cross compiler, so it can't execute on the build host.
    (lib.cmakeBool "GRAPHBLAS_USE_JIT" false)
  ];

  env = lib.optionalAttrs effectiveStdenv.hostPlatform.isDarwin {
    # Ensure that there is enough space for the `fixDarwinDylibNames` hook to
    # update the install names of the output dylibs.
    NIX_LDFLAGS = "-headerpad_max_install_names";
  };

  # CMAKE build does not automatically provide doc output, so we make it ourselves
  postInstall = ''
    docdir=$doc/share/doc/${finalAttrs.pname}-${finalAttrs.version}
    mkdir -p $docdir

    # Top-level docs
    cp $src/LICENSE.txt $src/ChangeLog $src/README.md $docdir/

    # Per-component READMEs, licenses, and changelogs
    for f in $src/*/README.txt $src/*/README.md $src/*/LICENSE $src/*/LICENSE.txt $src/*/ChangeLog; do
      [ -f "$f" ] || continue
      component=$(basename $(dirname "$f"))
      cp "$f" "$docdir/''${component}_$(basename "$f")"
    done

    # User guides and papers from Doc directories
    for dir in $src/*/Doc; do
      [ -d "$dir" ] || continue
      component=$(basename $(dirname "$dir"))
      find "$dir" -name '*.pdf' -exec cp {} "$docdir/" \;
    done
  '';

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
  };
})
