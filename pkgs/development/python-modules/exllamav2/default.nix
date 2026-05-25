{
  fetchFromGitHub,
  lib,
  cudaPackages,
  buildPythonPackage,
  nix-update-script,

  setuptools,

  pybind11,

  which,

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
  torch,
  websockets,
}:
buildPythonPackage (finalAttrs: {
  pname = "exllamav2";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "turboderp-org";
    repo = "exllamav2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WbpbANenOuy6F0qAKVKAmolHjgRKfPxSVud8FZG1TXw=";
  };

  build-system = [
    setuptools
  ];

  buildInputs = [
    pybind11
  ]
  ++ lib.optionals torch.cudaSupport [
    cudaPackages.libcusparse # cusparse.h
    cudaPackages.libcublas # cublas_v2.h
    cudaPackages.libcusolver # cusolverDn.h
    cudaPackages.libcurand # curand_kernel.h
    cudaPackages.cuda_cudart # cuda_runtime.h
  ];

  env = lib.optionalAttrs torch.cudaSupport {
    CUDA_HOME = lib.getDev cudaPackages.cuda_nvcc;
    TORCH_CUDA_ARCH_LIST = lib.concatStringsSep ";" torch.cudaCapabilities;
  };

  nativeBuildInputs = [
    ninja
    which
  ];

  pythonRelaxDeps = [
    "numpy" # Wants numpy 1.26.4
  ];

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

  passthru.updateScript = nix-update-script { };

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
