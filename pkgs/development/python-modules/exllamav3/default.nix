{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  cudaPackages,
  nix-update-script,

  setuptools,

  flash-linear-attention,
  llguidance,
  marisa-trie,
  ninja,
  numpy,
  pillow,
  pydantic,
  pyyaml,
  rich,
  safetensors,
  tokenizers,
  torch,
  typing-extensions,
}:
let
  # https://github.com/turboderp-org/exllamav3/blob/master/.github/workflows/build.yml#L55
  # https://github.com/turboderp-org/exllamav3/issues/44
  # Using unsupported platforms the build will fail
  cudaCapabilities = lib.intersectLists torch.cudaCapabilities [
    "8.0"
    "8.6"
    "8.9"
    "9.0"
    "10.0"
    "12.0"
  ];
in
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "exllamav3";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "turboderp-org";
    repo = "exllamav3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C2wwGC7IMrEmYYCKwVALsV2LtGpdYnz+2DVWlTLXv18=";
  };

  pythonRelaxDeps = [
    "pydantic"
  ];

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    ninja
  ];

  buildInputs = lib.optionals torch.cudaSupport [
    cudaPackages.cuda_cudart # cuda_runtime.h
    cudaPackages.libcusparse # cusparse.h
    cudaPackages.libcublas # cublas_v2.h
    cudaPackages.libcusolver # cusolverDn.h
    cudaPackages.libcurand # curand_kernel.h
  ];

  dependencies = [
    flash-linear-attention # Upstream vendors it instead
    llguidance
    marisa-trie
    numpy
    pillow
    pydantic
    pyyaml
    rich
    safetensors
    tokenizers
    torch
    typing-extensions
  ];

  env = lib.optionalAttrs torch.cudaSupport {
    CUDA_HOME = lib.getDev cudaPackages.cuda_nvcc;
    TORCH_CUDA_ARCH_LIST = lib.concatStringsSep ";" (
      cudaCapabilities ++ [ "${lib.last cudaCapabilities}+PTX" ]
    );
  };

  pythonImportsCheck = [ "exllamav3" ];

  # Tests require GPU hardware and external model files
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Quantization and inference library for running LLMs locally on modern consumer-class GPUs";
    homepage = "https://github.com/turboderp-org/exllamav3";
    changelog = "https://github.com/turboderp-org/exllamav3/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = [
      "x86_64-windows"
      "x86_64-linux"
    ];
    broken = !torch.cudaSupport; # Package requires CUDA for functionality
    maintainers = with lib.maintainers; [ BatteredBunny ];
  };
})
