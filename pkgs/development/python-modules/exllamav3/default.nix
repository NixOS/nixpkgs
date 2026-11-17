{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  cudaPackages,
  nix-update-script,

  setuptools,

  llguidance,
  marisa-trie,
  ninja,
  numpy,
  pillow,
  pybind11,
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
    "7.5"
    "8.0"
    "8.6"
    "8.9"
    "9.0"
    "10.0"
    "12.0"
  ];

  # https://github.com/turboderp-org/exllamav3/blob/master/.github/workflows/build.yml#L77
  # Only consumer RDNA cards are supported
  rocmGpuTargets = lib.filter (lib.hasPrefix "gfx1") (lib.splitString ";" torch.gpuTargetString);

  inherit (torch) rocmPackages;

  stdenv = if torch.rocmSupport then rocmPackages.stdenv else torch.stdenv;
in
buildPythonPackage.override { inherit stdenv; } (finalAttrs: {
  pname = "exllamav3";
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "turboderp-org";
    repo = "exllamav3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q13szUdWsvXagzsqFwbzTIJa0ulsNsZV78UIoPdVH9k=";
  };

  pythonRelaxDeps = [
    "pydantic"
  ];

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    ninja
  ]
  ++ lib.optionals torch.rocmSupport [
    rocmPackages.clr
  ];

  buildInputs = lib.optionals torch.cudaSupport [
    cudaPackages.cuda_cudart # cuda_runtime.h
    cudaPackages.libcusparse # cusparse.h
    cudaPackages.libcublas # cublas_v2.h
    cudaPackages.libcusolver # cusolverDn.h
    cudaPackages.libcurand # curand_kernel.h
  ];

  dependencies = [
    # Upstream has a vendored modified flash-linear-attention
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

  env =
    lib.optionalAttrs torch.cudaSupport {
      CUDA_HOME = lib.getDev cudaPackages.cuda_nvcc;
      TORCH_CUDA_ARCH_LIST = lib.concatStringsSep ";" (
        cudaCapabilities ++ [ "${lib.last cudaCapabilities}+PTX" ]
      );
    }
    // lib.optionalAttrs torch.rocmSupport {
      ROCM_HOME = torch.rocmtoolkit_joined;
      PYTORCH_ROCM_ARCH = lib.concatStringsSep ";" rocmGpuTargets;
      CPLUS_INCLUDE_PATH = lib.makeIncludePath [ pybind11 ];
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
    broken = !(torch.cudaSupport || torch.rocmSupport); # Requires CUDA or ROCM for functionality
    maintainers = with lib.maintainers; [ BatteredBunny ];
  };
})
