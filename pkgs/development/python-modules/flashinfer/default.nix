# NOTE: At runtime, FlashInfer will fall back to PyTorch’s JIT compilation if a
# requested kernel wasn’t pre-compiled in AOT mode, and JIT compilation always
# requires the CUDA toolkit (via nvcc) to be available.
#
# This means that if you plan to use flashinfer, you will need to set the
# environment variable `CUDA_HOME` to `cudatoolkit`.
{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  apache-tvm-ffi,
  packaging,
  setuptools,

  # nativeBuildInputs
  cmake,
  ninja,
  cudaPackages,

  # dependencies
  click,
  cuda-tile,
  einops,
  numpy,
  nvidia-cutlass-dsl,
  nvidia-ml-py,
  tabulate,
  torch,
  tqdm,

  cudaSupport ? torch.cudaSupport,
}:

buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "flashinfer";
  version = "0.6.12";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "flashinfer-ai";
    repo = "flashinfer";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-UhLDUM5sNJdOYiEV2wGMdbijsi+SrIi7wgU7eDAJlW8=";
  };

  build-system = [
    apache-tvm-ffi
    packaging
    setuptools
  ];

  nativeBuildInputs = [
    cmake
    ninja
    (lib.getBin cudaPackages.cuda_nvcc)
  ];

  dontUseCmakeConfigure = true;

  buildInputs =
    (with cudaPackages; [
      cccl
      cuda_cudart
      libcublas
      libcurand
    ])
    ++ [ cuda-tile ];

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

  env = {
    FLASHINFER_CUDA_ARCH_LIST = lib.concatStringsSep ";" torch.cudaCapabilities;
  };

  pythonRemoveDeps = [
    "nvidia-cudnn-frontend"
  ];
  dependencies = [
    click
    einops
    numpy
    nvidia-cutlass-dsl
    nvidia-ml-py
    tabulate
    torch
    tqdm
  ];

  doCheck = true;

  meta = {
    broken = !cudaSupport;
    homepage = "https://flashinfer.ai/";
    downloadPage = "https://github.com/flashinfer-ai/flashinfer";
    changelog = "https://github.com/flashinfer-ai/flashinfer/releases/tag/${finalAttrs.src.tag}";
    description = "Library and kernel generator for Large Language Models";
    longDescription = ''
      FlashInfer is a library and kernel generator for Large Language Models
      that provides high-performance implementation of LLM GPU kernels such as
      FlashAttention, PageAttention and LoRA. FlashInfer focus on LLM serving
      and inference, and delivers state-of-the-art performance across diverse
      scenarios.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      breakds
      daniel-fahey
    ];
  };
})
