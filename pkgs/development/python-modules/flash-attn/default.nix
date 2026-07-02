{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  einops,
  ninja,
  setuptools,
  symlinkJoin,
  torch,
}:

let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;
  inherit (cudaPackages) backendStdenv;
in
buildPythonPackage rec {
  pname = "flash-attention";
  version = "2.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "flash-attention";
    tag = "v${version}";
    hash = "sha256-iHxfDh+rGanhymP5F7g8rQcQUlP0oXliVF+y+ur/iJ0=";
    fetchSubmodules = true;
  };

  preConfigure = ''
    export MAX_JOBS="$NIX_BUILD_CORES"
    export NVCC_THREADS="$NIX_BUILD_CORES"
  '';

  env = lib.optionalAttrs cudaSupport {
    FLASH_ATTENTION_SKIP_CUDA_BUILD = "FALSE";
    CC = "${backendStdenv.cc}/bin/cc";
    CXX = "${backendStdenv.cc}/bin/c++";
    TORCH_CUDA_ARCH_LIST = "${lib.concatStringsSep ";" cudaCapabilities}";
  };

  build-system = [
    ninja
    setuptools
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

  # Requires NVIDIA driver.
  doCheck = false;

  pythonImportsCheck = [ "flash_attn" ];

  meta = {
    # Upstream requires either CUDA or ROCm. Couldn't get it to work with ROCm for now.
    broken = !cudaSupport;
    description = "Official implementation of FlashAttention and FlashAttention-2";
    homepage = "https://github.com/Dao-AILab/flash-attention/";
    changelog = "https://github.com/Dao-AILab/flash-attention/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
