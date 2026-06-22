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
      cp311 = "sha256-IYsM/q+MMYSTNjUDL1icbBkFE/Pv4LIysFtp0LW+XEs=";
      cp312 = "sha256-oz2DkFz8p6LbIDSi9liUECR1XXXBtQDJOqy+YWTsAwA=";
      cp313 = "sha256-Gd4Dm7NJa6qAbPIsimi5id2ZihKYR9PYu4MNNLp3fwg=";
      cp314 = "sha256-Xj3sJ4B7XSQ0eeWX8shGtWC4m4DXfyUmiWOeZzcxPRA=";
    };
    aarch64-linux = {
      cp311 = "sha256-0I/rlCm9hyAi0B/XkKapze1XoU9OorJSXtYu5KMvX38=";
      cp312 = "sha256-l2g+5iMexXxPe/0s5TFx1/o4Bc+PMH3dI47XVwdEbNs=";
      cp313 = "sha256-/ikvI1LniluT91AYEaA199iUX8GYZCawvozueoy7Lh8=";
      cp314 = "sha256-M/2vaRZTr0UgbH5BFK1T6/8mCxqDdAHlSXdc2dDMJo8=";
    };
  };
in
buildPythonPackage (finalAttrs: {
  pname = "nvidia-cutlass-dsl-libs-base";
  version = "4.6.0.dev0";
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
  pythonRelaxDeps = [
    "protobuf"
  ];
  dependencies = [
    cuda-bindings
    numpy
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
