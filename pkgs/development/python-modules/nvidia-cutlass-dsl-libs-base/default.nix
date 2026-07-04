{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  python,

  # nativeBuildInputs
  autoAddDriverRunpath,
  autoPatchelfHook,

  # dependencies
  cuda-bindings,
  numpy,
  nvidia-cutlass-dsl-libs-core,
  protobuf,
  typing-extensions,
}:

let
  platform =
    {
      x86_64-linux = "manylinux_2_28_x86_64";
      aarch64-linux = "manylinux_2_28_aarch64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "nvidia-cutlass-dsl-libs-base is not supported on ${stdenv.hostPlatform.system}");

  pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";

  hashes = {
    x86_64-linux = {
      cp311 = "sha256-XJ/6O3Z94/CYcBjeikOPoDRMusQfbS5+haP5wJwfsZQ=";
      cp312 = "sha256-DuPKQnpDvTGQ/ErAb7oV+nqSMkGhzJKNPitKb0gNvTk=";
      cp313 = "sha256-miKupg5UmqJRSLx9Vw5SYWGy6ZAxs5DPErFteTi8lbQ=";
      cp314 = "sha256-F/mhzISIosVwgskn41cbHRXbUi//2L0vk1HJqrpYyJ4=";
    };
    aarch64-linux = {
      cp311 = "sha256-/sAjdWLFrW4M0cZqwpuABYN0oubswBkjuQGmFH1EnHg=";
      cp312 = "sha256-yN/c5uVc2Fb9Os5HuIHEHo9x++05bM3reHDRk1bxavc=";
      cp313 = "sha256-v+/dVRIS4QcW9akCvoQ3roBkRVjw0gp8z6mQNz6Wxzk=";
      cp314 = "sha256-Vq6JVU2Hz6vIMwwLCHERJh9NzrC3ByCwHf/wPJFvMIQ=";
    };
  };
in
buildPythonPackage (finalAttrs: {
  pname = "nvidia-cutlass-dsl-libs-base";
  version = "4.7.0";
  format = "wheel";
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "nvidia_cutlass_dsl_libs_base";
    inherit (finalAttrs) version;
    format = "wheel";
    inherit platform;
    dist = pyShortVersion;
    python = pyShortVersion;
    abi = pyShortVersion;
    hash =
      hashes.${stdenv.hostPlatform.system}.${pyShortVersion}
        or (throw "No hash specified for '${stdenv.hostPlatform.system}.${pyShortVersion}'");
  };

  pythonRemoveDeps = [
    # Only cuda-bindings is needed
    "cuda-python"

    # just a wrapper for cudaPackages.cuda_nvdisasm
    "nvidia-cuda-nvdisasm"
  ];
  pythonRelaxDeps = [
    "protobuf"
  ];
  dependencies = [
    cuda-bindings
    numpy
    nvidia-cutlass-dsl-libs-core
    protobuf
    typing-extensions
  ];

  nativeBuildInputs = [
    autoAddDriverRunpath
    autoPatchelfHook
  ];

  autoPatchelfIgnoreMissingDeps = [
    # libmlir_cuda_runtime.so links libcuda.so.1
    # autoAddDriverRunpath bakes the driver path into the runpath; tell autoPatchelfHook not to fail
    # on it.
    "libcuda.so.1"
  ];

  # This wheel ships the `cutlass` module nested under `nvidia_cutlass_dsl/python_packages/`,
  # exposed at the top level via `nvidia_cutlass_dsl.pth`.
  # Python only processes `.pth` files in directories registered as site dirs by `site.py`, not in
  # PYTHONPATH entries.
  # In nixpkgs, `buildPythonPackage` propagates dependencies via PYTHONPATH
  # (see python's setup-hook), so any downstream consumer (e.g. flash-attn) would not see the
  # `cutlass` module.
  # `withPackages` envs work fine because they merge everything into a real site dir.
  # Symlinking `cutlass` to the site-packages root makes it importable in both modes.
  postFixup = ''
    ln -s nvidia_cutlass_dsl/python_packages/cutlass $out/${python.sitePackages}/cutlass
  '';

  pythonImportsCheck = [ "cutlass" ];

  # No tests in the Pypi archive
  doCheck = false;

  meta = {
    description = "Bundled MLIR/CUDA runtime libraries and Python sources for the NVIDIA CUTLASS DSL";
    homepage = "https://github.com/NVIDIA/cutlass";
    changelog = "https://github.com/NVIDIA/cutlass/blob/v${finalAttrs.version}/CHANGELOG.md";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable; # NVIDIA Proprietary
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
  };
})
