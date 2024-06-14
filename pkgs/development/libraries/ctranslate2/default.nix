{ config
, lib
, stdenv
, fetchFromGitHub
, cmake
, darwin # Accelerate
, llvmPackages # openmp
, withMkl ? false, mkl
, withCUDA ? config.cudaSupport
, withCuDNN ? (withCUDA && (cudaPackages ? cudnn))
, cudaPackages
# Enabling both withOneDNN and withOpenblas is broken
# https://github.com/OpenNMT/CTranslate2/issues/1294
, withOneDNN ? false, oneDNN
, withOpenblas ? true, openblas
, withRuy ? true

# passthru tests
, libretranslate
, wyoming-faster-whisper
}@inputs:

let
  inherit (lib.strings) cmakeBool cmakeFeature;
  stdenv = builtins.throw "Use effectiveStdenv instead of stdenv in this derivation.";
  effectiveStdenv = if withCUDA then cudaPackages.backendStdenv else inputs.stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "ctranslate2";
  version = "4.3.1";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "OpenNMT";
    repo = "CTranslate2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ApmGto9RzT8t49bsZVwk8aQnIau9sQyFvt9qnWKUGAE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals withCUDA [
    cudaPackages.cuda_nvcc
  ];

  cudaEnableCmakeFindCudaToolkitSupport = true;

  cmakeFlags = [
    # https://opennmt.net/CTranslate2/installation.html#build-options
    # https://github.com/OpenNMT/CTranslate2/blob/54810350e662ebdb01ecbf8e4a746f02aeff1dd7/python/tools/prepare_build_environment_linux.sh#L53
    # https://github.com/OpenNMT/CTranslate2/blob/59d223abcc7e636c1c2956e62482bc3299cc7766/python/tools/prepare_build_environment_macos.sh#L12
    (cmakeFeature "OPENMP_RUNTIME" "COMP")
    (cmakeBool "WITH_CUDA" withCUDA)
    (cmakeBool "WITH_CUDNN" withCuDNN)
    (cmakeBool "WITH_DNNL" withOneDNN)
    (cmakeBool "WITH_OPENBLAS" withOpenblas)
    (cmakeBool "WITH_RUY" withRuy)
    (cmakeBool "WITH_MKL" withMkl)
    (cmakeBool "WITH_ACCELERATE" effectiveStdenv.isDarwin)
  ] ++ lib.optionals withCUDA [
    (cmakeFeature "CMAKE_CXX_FLAGS" "-Wno-unused-parameter") # Reduce log spam for generated code
    (cmakeFeature "CUDA_ARCH_LIST" (lib.concatStringsSep ";" cudaPackages.cudaFlags.cudaCapabilities))
  ];

  buildInputs = lib.optionals withMkl [
    mkl
  ] ++ lib.optionals withCUDA [
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
    cudaPackages.libcurand.dev
  ] ++ lib.optionals (withCUDA && withCuDNN) [
    cudaPackages.cudnn.dev
    cudaPackages.cudnn.lib
  ] ++ lib.optionals withOneDNN [
    oneDNN
  ] ++ lib.optionals withOpenblas [
    openblas
  ] ++ lib.optionals effectiveStdenv.isDarwin [
    llvmPackages.openmp
    darwin.apple_sdk.frameworks.Accelerate
  ] ++ lib.optionals (effectiveStdenv.isDarwin && effectiveStdenv.isx86_64) [
    darwin.apple_sdk.frameworks.CoreGraphics
    darwin.apple_sdk.frameworks.CoreVideo
  ];

  passthru.tests = {
    inherit
      libretranslate
      wyoming-faster-whisper
    ;
  };

  meta = with lib; {
    description = "Fast inference engine for Transformer models";
    mainProgram = "ct2-translator";
    homepage = "https://github.com/OpenNMT/CTranslate2";
    changelog = "https://github.com/OpenNMT/CTranslate2/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa misuzu ];
    broken =
      (cudaPackages.cudaOlder "11.4")
      || !(withCuDNN -> withCUDA);
  };
})
