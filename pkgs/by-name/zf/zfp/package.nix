{
  cmake,
  fetchFromGitHub,
  gfortran,
  lib,
  llvmPackages,
  python3Packages,
  cudaPackages,
  stdenv,
  config,
  testers,
  bitStreamWordSize ? 64,
  enableCfp ? true,
  enableCuda ? config.cudaSupport,
  enableFortran ? builtins.elem stdenv.hostPlatform.system gfortran.meta.platforms,
  enableOpenMP ? true,
  enablePython ? true,
  enableUtilities ? true,
}@inputs:

let
  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if enableCuda then cudaPackages.backendStdenv else inputs.stdenv;
in

effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "zfp";
  version = "1.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "zfp";
    tag = finalAttrs.version;
    hash = "sha256-iZxA4lIviZQgaeHj6tEQzEFSKocfgpUyf4WvUykb9qk=";
  };

  patches = [
    # part of https://github.com/LLNL/zfp/pull/217
    # Remove distutils
    ./python312.patch
  ];

  nativeBuildInputs = [ cmake ] ++ lib.optionals enableCuda [ cudaPackages.cuda_nvcc ];

  buildInputs =
    lib.optionals enableCuda [ cudaPackages.cuda_cudart ]
    ++ lib.optionals enableFortran [ gfortran ]
    ++ lib.optionals enablePython (
      with python3Packages;
      [
        cython
        numpy
        python
      ]
    );

  propagatedBuildInputs = lib.optionals (enableOpenMP && effectiveStdenv.cc.isClang) [
    llvmPackages.openmp
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_CFP" enableCfp)
    (lib.cmakeBool "BUILD_ZFORP" enableFortran)
    (lib.cmakeBool "ZFP_WITH_OPENMP" enableOpenMP)
    (lib.cmakeBool "BUILD_ZFPY" enablePython)
    (lib.cmakeBool "BUILD_UTILITIES" enableUtilities)
    (lib.cmakeBool "ZFP_WITH_CUDA" enableCuda)
  ]
  # compile CUDA code for all extant GPUs so the binary will work with any GPU
  # and driver combination. to be ultimately solved upstream:
  # https://github.com/LLNL/zfp/issues/178
  ++ lib.optionals enableCuda [
    (lib.cmakeFeature "CMAKE_CUDA_FLAGS" (toString [
      "-gencode=arch=compute_52,code=sm_52"
      "-gencode=arch=compute_60,code=sm_60"
      "-gencode=arch=compute_61,code=sm_61"
      "-gencode=arch=compute_70,code=sm_70"
      "-gencode=arch=compute_75,code=sm_75"
      "-gencode=arch=compute_80,code=sm_80"
      "-gencode=arch=compute_86,code=sm_86"
      "-gencode=arch=compute_87,code=sm_87"
      "-gencode=arch=compute_86,code=compute_86"
    ]))
  ]
  ++ lib.optionals (bitStreamWordSize != 64) [
    (lib.cmakeFeature "ZFP_BIT_STREAM_WORD_SIZE" (toString bitStreamWordSize))
  ];

  doCheck = true;

  # the testzfp regression test only supports the default 64-bit bitstream word
  checkFlags = lib.optionals (bitStreamWordSize != 64) [
    "ARGS=\"--exclude-regex testzfp\""
  ];

  passthru.tests = {
    cmake-config = testers.hasCmakeConfigModules {
      moduleNames = [ "zfp" ];
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    homepage = "https://computing.llnl.gov/projects/zfp";
    description = "Library for random-access compression of floating-point arrays";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.spease ];
    # 64-bit only
    platforms = lib.platforms.aarch64 ++ lib.platforms.x86_64;
    mainProgram = "zfp";
  };
})
