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
      cp311 = "sha256-kReQDLpT08Iajay6a789bl8mnkJ6UmwyD7RHB6DVc2M=";
      cp312 = "sha256-Fe9qWRk2Z+Zjk070hz+MytN0Vem3w8QZwwchE7iu32E=";
      cp313 = "sha256-5Z2n2J5eT4UUxlMIQ/kQ+dhzTYBC3KoHnJ2cUGPrNRQ=";
      cp314 = "sha256-EsKffB8fgoUQkro4aSZNr6+wNSKMDZgnqNsIuIT7gMo=";
    };
    aarch64-linux = {
      cp311 = "sha256-y7VVqVxwEeSzyjKL5AcpnHfSiWYK2+oi7VFdRAbmlJw=";
      cp312 = "sha256-0qPEEih+NW++SP6fhF1tM8013qXiDX5PYowglXlnys0=";
      cp313 = "sha256-OVvXfPZCru8xExNFPmWC8RyTV6S4H+Yg6j2szR/Mq5s=";
      cp314 = "sha256-IW7uaqgQfTVWn5RRtmsDo8UxZ4QdGvm2MLlm742Wbhk=";
    };
  };
in
buildPythonPackage (finalAttrs: {
  pname = "nvidia-cutlass-dsl-libs-base";
  version = "4.5.2";
  format = "wheel";

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
  ];
  dependencies = [
    cuda-bindings
    numpy
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
