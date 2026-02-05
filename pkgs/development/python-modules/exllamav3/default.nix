{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  cudaPackages,
  nix-update-script,

  setuptools,

  flash-attn,
  formatron,
  kbnf,
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
  newerThanTuring = lib.filter (version: lib.versionOlder "7.9" version) torch.cudaCapabilities;
in
buildPythonPackage (finalAttrs: {
  pname = "exllamav3";
  version = "0.0.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "turboderp-org";
    repo = "exllamav3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G3PtxKU/J4JEQQOwFmrSWuSr/hA4uyxRci3khXCwEqE=";
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
    flash-attn
    formatron
    kbnf
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
    # exllamav3 only supports turing or newer GPUs
    # https://github.com/turboderp-org/exllamav3/issues/44
    TORCH_CUDA_ARCH_LIST = lib.concatStringsSep ";" newerThanTuring;
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
