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

  # build-system
  apache-tvm-ffi,
  packaging,
  setuptools,

  # nativeBuildInputs
  cudaPackages,
  ninja,

  # dependencies
  click,
  cuda-bindings,
  cuda-core,
  cuda-pathfinder,
  cuda-tile,
  einops,
  nccl4py,
  numpy,
  nvidia-cudnn-frontend,
  nvidia-cutlass-dsl,
  nvidia-ml-py,
  requests,
  tabulate,
  torch,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "flashinfer";
  version = "0.6.16.post3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "flashinfer-ai";
    repo = "flashinfer";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-mhmjIX1Whats3JUjrMr27mY7o3DR4D/Wg5XCJrFHqEY=";
  };

  enableParallelBuilding = true;

  preBuild = ''
    export MAX_JOBS="$NIX_BUILD_CORES"
    export FLASHINFER_WORKSPACE_BASE="$TMPDIR/flashinfer-workspace"
    mkdir -p $FLASHINFER_WORKSPACE_BASE
  '';

  build-system = [
    apache-tvm-ffi
    packaging
    setuptools
  ];

  nativeBuildInputs = [
    ninja
    (lib.getBin cudaPackages.cuda_nvcc)
  ];

  buildInputs = with cudaPackages; [
    cccl
    cuda_cudart
    libcublas
    libcurand
  ];

  env = {
    TORCH_NVCC_FLAGS = "--maxrregcount=64";
    FLASHINFER_CUDA_ARCH_LIST = lib.concatStringsSep ";" torch.cudaCapabilities;
  };

  pythonRemoveDeps = [
    # `cuda-python` (github:NVIDIA/cuda-python) is a repository of
    # various sub-packages and we (nixpkgs) have packaged all of them
    # in cuda-bindings` `cuda-core` `cuda-pathfinder` `cuda-tile`.
    # so remove the meta-package entry
    "cuda-python"
  ];

  dependencies = [
    click
    cuda-bindings
    cuda-core
    cuda-pathfinder
    cuda-tile
    einops
    nccl4py
    numpy
    nvidia-cudnn-frontend
    nvidia-cutlass-dsl
    nvidia-ml-py
    requests
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
})
