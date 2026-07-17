{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  ninja,
  setuptools,
  torch,

  # dependencies
  einops,

  # passthru
  nix-update-script,
}:

let
  inherit (torch) cudaCapabilities cudaPackages cudaSupport;
in
buildPythonPackage.override { inherit (torch) stdenv; } (finalAttrs: {
  pname = "flash-attn-3";
  version = "3.0.0-unstable-2026-06-10";
  pyproject = true;
  __structuredAttrs = true;

  # We fetch the vendored CUTLASS submodule rather than relying on `cudaPackages.cutlass`.
  # FA3 reaches deep into private cute/cutlass internals and is likely to be incompatible with
  # whatever version of cutlass we currently package.
  # Upstream pins a specific submodule SHA that is often an unreleased commit on master, strictly
  # between two tagged versions, so neither the previous nor the next stable tag will compile.
  # Using the vendored submodule is the only way to guarantee a matching set of headers.
  src = fetchFromGitHub {
    owner = "Dao-AILab";
    repo = "flash-attention";
    rev = "fc8cbad6b6b90220cf6ef8121c29e299a3ba7d9a";
    hash = "sha256-6HxeLAahkWO5pghszfLS6i8Ju67sAxjWnDk0RYRuY88=";
    fetchSubmodules = true;
  };

  sourceRoot = "${finalAttrs.src.name}/hopper";

  postPatch =
    # The submodule is fetched by fetchFromGitHub, no need to update it at build time
    ''
      substituteInPlace setup.py \
        --replace-fail \
          'subprocess.run(["git", "submodule", "update", "--init", "../csrc/cutlass"])' \
          'pass'
    ''
    # Prevent setup.py from downloading a custom NVCC version
    + ''
      substituteInPlace setup.py \
        --replace-fail \
          'if bare_metal_version >= Version("12.3") and bare_metal_version < Version("13.0") and bare_metal_version != Version("12.8"):' \
          'if False:'
    '';

  preConfigure = ''
    export MAX_JOBS="$NIX_BUILD_CORES"
    export NVCC_THREADS=2
  '';

  env = {
    FLASH_ATTENTION_FORCE_BUILD = "TRUE";
    FLASH_ATTENTION_SKIP_CUDA_BUILD = "FALSE";

    # 8.0;9.0;12.0
    TORCH_CUDA_ARCH_LIST = lib.concatStringsSep ";" cudaCapabilities;
  };

  build-system = [
    ninja
    setuptools
    torch
  ];

  nativeBuildInputs = [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    cudaPackages.cuda_cudart # cuda_runtime.h cuda_runtime_api.h
  ];

  dependencies = [
    einops
    torch
  ];

  pythonImportsCheck = [
    "flash_attn_config"
    "flash_attn_interface"
  ];

  # Tests require access to a physical GPU
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--version-regex=v(3.*)"
    ];
  };

  meta = {
    description = "Official implementation of FlashAttention-3";
    homepage = "https://github.com/Dao-AILab/flash-attention/blob/main/hopper";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    # Upstream requires either CUDA or ROCm. ROCm support is not (yet) supported in nixpkgs
    broken = !cudaSupport;
  };
})
