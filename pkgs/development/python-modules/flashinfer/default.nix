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
  fetchpatch2,

  # build-system
  setuptools,

  # nativeBuildInputs
  cmake,
  ninja,
  cudaPackages,

  # dependencies
  click,
  einops,
  numpy,
  nvidia-ml-py,
  tabulate,
  torch,
  tqdm,
}:

buildPythonPackage rec {
  pname = "flashinfer";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flashinfer-ai";
    repo = "flashinfer";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-e9PfLfU0DdoLKlXiHylCbGd125c7Iw9y4NDIOAP0xHs=";
  };

  patches = [
    # TODO: remove patch with update to v0.5.2+
    # Switch pynvml to nvidia-ml-py
    (fetchpatch2 {
      url = "https://github.com/flashinfer-ai/flashinfer/commit/a42f99255d68d1a54b689bd4985339c6b44963a6.patch?full_index=1";
      hash = "sha256-3XJFcdQeZ/c5fwiQvd95z4p9BzTn8pjle21WzeBxUgk=";
    })
  ];

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cmake
    ninja
    (lib.getBin cudaPackages.cuda_nvcc)
  ];

  dontUseCmakeConfigure = true;

  buildInputs = with cudaPackages; [
    cuda_cccl
    cuda_cudart
    libcublas
    libcurand
  ];

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

  FLASHINFER_CUDA_ARCH_LIST = lib.concatStringsSep ";" torch.cudaCapabilities;

  pythonRemoveDeps = [
    "nvidia-cudnn-frontend"
  ];
  dependencies = [
    click
    einops
    numpy
    nvidia-ml-py
    tabulate
    torch
    tqdm
  ];

  meta = {
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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      breakds
      daniel-fahey
    ];
  };
}
