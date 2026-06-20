{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  torch,

  cudaPackages,

  # nativeBuildInputs
  pybind11,

  # dependencies
  fastparquet,
  flash-attn,
  ninja,
  numpy,
  pandas,
  pillow,
  pygments,
  regex,
  rich,
  safetensors,
  tokenizers,
  websockets,
}:
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "exllamav2";
  version = "0.3.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "turboderp-org";
    repo = "exllamav2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WbpbANenOuy6F0qAKVKAmolHjgRKfPxSVud8FZG1TXw=";
  };

  build-system = [
    setuptools
    torch
  ];

  nativeBuildInputs = [
    ninja
  ];

  preConfigure = ''
    export MAX_JOBS="$NIX_BUILD_CORES"
    export NVCC_THREADS=2
  '';

  buildInputs = [
    pybind11
  ]
  ++ lib.optionals torch.cudaSupport [
    cudaPackages.cuda_cudart # cuda_runtime.h
    cudaPackages.libcublas # cublas_v2.h
    cudaPackages.libcurand # curand_kernel.h
    cudaPackages.libcusolver # cusolverDn.h
    cudaPackages.libcusparse # cusparse.h
  ];

  env = lib.optionalAttrs torch.cudaSupport {
    CUDA_HOME = lib.getDev cudaPackages.cuda_nvcc;
    TORCH_CUDA_ARCH_LIST = lib.concatStringsSep ";" torch.cudaCapabilities;
  };

  dependencies = [
    fastparquet
    flash-attn
    ninja
    numpy
    pandas
    pillow
    pygments
    regex
    rich
    safetensors
    tokenizers
    torch
    websockets
  ];

  pythonImportsCheck = [ "exllamav2" ];

  # Tests require GPU hardware and external model files
  doCheck = false;

  meta = {
    homepage = "https://github.com/turboderp-org/exllamav2";
    description = "Inference library for running LLMs locally on modern consumer-class GPUs";
    changelog = "https://github.com/turboderp-org/exllamav2/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-windows"
      "x86_64-linux"
    ];

    # Package requires CUDA or ROCm for functionality
    # ROCm support is partially implemented but untested
    broken = !torch.cudaSupport;
    maintainers = with lib.maintainers; [ BatteredBunny ];
  };
})
