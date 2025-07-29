# NOTE: At runtime, FlashInfer will fall back to PyTorch’s JIT compilation if a
# requested kernel wasn’t pre-compiled in AOT mode, and JIT compilation always
# requires the CUDA toolkit (via nvcc) to be available.
#
# This means that if you plan to use flashinfer, you will need to set the
# environment variable `CUDA_HOME` to `cudatoolkit`.
{
  lib,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cudaPackages,
  cmake,
  ninja,
  numpy,
  torch,
}:

let
  pname = "flashinfer";
  version = "0.2.5";

  src_cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    # Using the revision obtained in submodule inside flashinfer's `3rdparty`.
    rev = "df8a550d3917b0e97f416b2ed8c2d786f7f686a3";
    hash = "sha256-d4czDoEv0Focf1bJHOVGX4BDS/h5O7RPoM/RrujhgFQ=";
  };

in
buildPythonPackage {
  format = "setuptools";
  inherit pname version;

  src = fetchFromGitHub {
    owner = "flashinfer-ai";
    repo = "flashinfer";
    tag = "v${version}";
    hash = "sha256-YrYfatkI9DQkFEEGiF8CK/bTafaNga4Ufyt+882C0bQ=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cmake
    ninja
    (lib.getBin cudaPackages.cuda_nvcc)
  ];
  dontUseCmakeConfigure = true;

  buildInputs = [
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
    cudaPackages.cuda_cccl
    cudaPackages.libcurand
  ];

  postPatch = ''
    rmdir 3rdparty/cutlass
    ln -s ${src_cutlass} 3rdparty/cutlass
  '';

  # FlashInfer offers two installation modes:
  #
  # JIT mode: CUDA kernels are compiled at runtime using PyTorch’s JIT, with
  # compiled kernels cached for future use. JIT mode allows fast installation,
  # as no CUDA kernels are pre-compiled, making it ideal for development and
  # testing. JIT version is also available as a sdist in PyPI.
  #
  # AOT mode: Core CUDA kernels are pre-compiled and included in the library,
  # reducing runtime compilation overhead. If a required kernel is not
  # pre-compiled, it will be compiled at runtime using JIT. AOT mode is
  # recommended for production environments.
  #
  # Here we use opt for the AOT version.
  preConfigure = ''
    export FLASHINFER_ENABLE_AOT=1
    export TORCH_NVCC_FLAGS="--maxrregcount=64"
    export MAX_JOBS="$NIX_BUILD_CORES"
  '';

  TORCH_CUDA_ARCH_LIST = lib.concatStringsSep ";" torch.cudaCapabilities;

  dependencies = [
    numpy
    torch
  ];

  meta = with lib; {
    broken = !torch.cudaSupport || !config.cudaSupport;
    homepage = "https://flashinfer.ai/";
    description = "Library and kernel generator for Large Language Models";
    longDescription = ''
      FlashInfer is a library and kernel generator for Large Language Models
      that provides high-performance implementation of LLM GPU kernels such as
      FlashAttention, PageAttention and LoRA. FlashInfer focus on LLM serving
      and inference, and delivers state-of-the-art performance across diverse
      scenarios.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ breakds ];
  };
}
