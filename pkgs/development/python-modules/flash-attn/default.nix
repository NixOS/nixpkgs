{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  ninja,
  setuptools,
  torch,

  # dependencies
  einops,

  # tests
  pytestCheckHook,

  # passthru
  flash-attn,
}:

let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;
in
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "flash-attention";
  version = "2.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "flash-attention";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-iHxfDh+rGanhymP5F7g8rQcQUlP0oXliVF+y+ur/iJ0=";
  };

  preConfigure = ''
    export MAX_JOBS="$NIX_BUILD_CORES"
    export NVCC_THREADS=2
  '';

  env = lib.optionalAttrs cudaSupport {
    FORCE_BUILD = "TRUE";
    FLASH_ATTENTION_SKIP_CUDA_BUILD = "FALSE";
    TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" cudaCapabilities}";
  };

  build-system = [
    ninja
    setuptools
    torch
  ];

  nativeBuildInputs = [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    cudaPackages.cuda_cccl # <thrust/*>
    cudaPackages.libcublas # cublas_v2.h
    cudaPackages.libcurand # curand.h
    cudaPackages.libcusolver # cusolverDn.h
    cudaPackages.libcusparse # cusparse.h
    cudaPackages.cuda_cudart # cuda_runtime.h cuda_runtime_api.h
  ];

  dependencies = [
    einops
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Requires NVIDIA driver.
  doCheck = false;

  pythonImportsCheck = [ "flash_attn" ];

  passthru.gpuCheck = flash-attn.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];
    doCheck = true;
  };

  meta = {
    # Upstream requires either CUDA or ROCm. Couldn't get it to work with ROCm for now.
    broken = !cudaSupport;
    description = "Official implementation of FlashAttention and FlashAttention-2";
    homepage = "https://github.com/Dao-AILab/flash-attention/";
    changelog = "https://github.com/Dao-AILab/flash-attention/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jherland ];
  };
})
