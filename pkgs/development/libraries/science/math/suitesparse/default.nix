{ blas
, cmake
, config
, cudaPackages
, enableCuda ? config.cudaSupport
, fetchFromGitHub
, fixDarwinDylibNames
, gfortran
, gmp
, lapack
, lib
, metis
, mpfr
, ninja
, openmp ? null
, stdenv
,
}@inputs:

let
  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if enableCuda then cudaPackages.backendStdenv else inputs.stdenv;
in
effectiveStdenv.mkDerivation rec {
  pname = "suitesparse";
  version = "7.12.1";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "SuiteSparse";
    rev = "v${version}";
    sha256 = "sha256-6EMPEH5dcNT1qtuSlzR26RhpfN7MbYJdSKcrsQ0Pzow=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ]
  ++ lib.optionals effectiveStdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_nvcc
  ];

  preConfigure = ''
    export GRAPHBLAS_CACHE_PATH=$(mktemp -d)
    mkdir -p $doc
  '';

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
      openmp
    ]
    ++ lib.optionals enableCuda [
      cudaPackages.cuda_cudart
      cudaPackages.cuda_cccl
      cudaPackages.libcublas
    ];

  cmakeFlags = [
    (lib.strings.cmakeBool "GRAPHBLAS_USE_JIT" true)
  ];

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
}
