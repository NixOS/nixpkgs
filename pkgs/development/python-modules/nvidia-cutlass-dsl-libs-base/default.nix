{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  python,
  cudaPackages,

  # nativeBuildInputs
  autoAddDriverRunpath,
  autoPatchelfHook,
  unzip,

  # dependencies
  cuda-bindings,
  numpy,
  protobuf,
  typing-extensions,
}:

let
  version = "4.8.0";

  inherit (stdenv.hostPlatform) system;

  platform =
    {
      x86_64-linux = "manylinux_2_28_x86_64";
      aarch64-linux = "manylinux_2_28_aarch64";
    }
    .${system} or (throw "nvidia-cutlass-dsl-libs-base is not supported on ${system}");

  pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";

  # Which CUDA toolkit flavor of the `_cutlass_ir` extension module to ship.
  ctk = "cu${cudaPackages.cudaMajorVersion}";

  hashes = {
    base = {
      x86_64-linux = {
        cp311 = "sha256-zjrsTDe2iIDoWn8/dj+P5NBQP0lRbMhVyAAS4PrfkuA=";
        cp312 = "sha256-W9yAmJsPu6w9WJYAV+dOLOhnb6+na4UtlCK5xLm3S90=";
        cp313 = "sha256-XjZ3N0j1qAYa/pmSZPHD3Mxf8Y7JVIqcdp2OcmMsiwA=";
        cp314 = "sha256-coq/G8Bl+pUK1PRQaSgwDX4y8xSDErk/g/Py6PdWMpo=";
      };
      aarch64-linux = {
        cp311 = "sha256-BN4Djgr2WLZEQhxN9MePFhodPCz55bzf9jskxyfc2Vw=";
        cp312 = "sha256-Ov/K77Wal2/1GV3Sv/TBNZQjPLSUFUC3TjcrY+SX0/I=";
        cp313 = "sha256-TSbdKEiy+gOVQVHP1tqSt54vQXXYf01mHu3HfDa3oFQ=";
        cp314 = "sha256-dS8XFdUKSvRwSqLxmZhrmWU7QN+1dN0MaqXPJk3dyAA=";
      };
    };
    cu12 = {
      x86_64-linux = {
        cp311 = "sha256-Xax675f8Ud+IK2hiDhxDDntDYtCsoX0iByfadoHwYd8=";
        cp312 = "sha256-I3TP3/Y1zq9+LFvRe0vrQQgwQgpP1lsSt/JLXVy7nUw=";
        cp313 = "sha256-oG6mpCySHsZrGQ8UhJ4VKpWkXyiBkhRIi5sKo0Fo2jM=";
        cp314 = "sha256-iJkYwy/mytBHrnGDQ/7bN0qcQnWQO0qy2PQugRpqDaw=";
      };
      aarch64-linux = {
        cp311 = "sha256-b4iuUtbirttKNP2jLJdKo1QwZM/u0/p+lhI8MkAv8so=";
        cp312 = "sha256-MnZoR6vjvvcR62BSq3jA8kwJDt0fgzIvbnRTHTmegRc=";
        cp313 = "sha256-CK8rifMwgd9ptkvhytEz+fdnJ0szZpiCy+5qX6NcX8w=";
        cp314 = "sha256-QfnUkIfxggDEUW4Aq63mf1QnlfNjx/GVu1NAS4GoZvg=";
      };
    };
    cu13 = {
      x86_64-linux = {
        cp311 = "sha256-GGZVnI2lw8CBUEeh+0FOF0X0cGmxS6xRaIhXhbhVPcI=";
        cp312 = "sha256-RjzX8MRS/+7stTChWusbEMu9LI2mxaov7PZfg2JYpzI=";
        cp313 = "sha256-QTeM+pTvPnQITVFXBk6oB6kglhI9N4aXotWL29WCJAo=";
        cp314 = "sha256-CdF1JKVfQN9BFhancbdTe+juBWYSaBq8cFQk7rswuo4=";
      };
      aarch64-linux = {
        cp311 = "sha256-uh7G1nHwCBUuc5hok1CWdtDgECqyQtUzSRgUzeXI50E=";
        cp312 = "sha256-1h6+JBbK6KLVN3iJVJ35y1AIrwBqFpLX0AbY90fmLmw=";
        cp313 = "sha256-V0Gng9wJ4pTa2mhEybjfj/FPzBnbIL5IIFWRGk+5tz8=";
        cp314 = "sha256-u9srFKdKNdOCowvubxfjH68Kq7bYeQmyuZx9E0psrBA=";
      };
    };
    core = "sha256-sycW0u0QwYXNu7a1xvyiajETpg5uL+Ti8MsVlmQitiE=";
  };

  fetchLibsWheel =
    flavor:
    fetchPypi {
      pname = "nvidia_cutlass_dsl_libs_${flavor}";
      inherit version platform;
      format = "wheel";
      dist = pyShortVersion;
      python = pyShortVersion;
      abi = pyShortVersion;
      hash =
        hashes.${flavor}.${system}.${pyShortVersion}
          or (throw "No ${flavor} hash specified for '${system}.${pyShortVersion}'");
    };

  # Pure-Python `cutlass` sources. They unpack into the very same
  # `nvidia_cutlass_dsl/dsl_packages/cutlass` directory as the wheels above, so all of them have to
  # end up in a single prefix.
  coreWheel = fetchPypi {
    pname = "nvidia_cutlass_dsl_libs_core";
    inherit version;
    format = "wheel";
    python = "py3";
    dist = "py3";
    hash = hashes.core;
  };
in
buildPythonPackage {
  pname = "nvidia-cutlass-dsl-libs-base";
  inherit version;
  format = "wheel";
  __structuredAttrs = true;

  src = fetchLibsWheel "base";

  pythonRemoveDeps = [
    # just a wrapper for cudaPackages.cuda_nvdisasm
    "nvidia-cuda-nvdisasm"

    # Bundled below
    "nvidia-cutlass-dsl-libs-core"
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
    unzip
  ];

  autoPatchelfIgnoreMissingDeps = [
    # libmlir_cuda_runtime.so links libcuda.so.1
    # autoAddDriverRunpath bakes the driver path into the runpath; tell autoPatchelfHook not to fail
    # on it.
    "libcuda.so.1"
  ];

  postInstall =
    # Merge in the remaining halves of the `cutlass` package: the pure-Python sources and the
    # CUDA-toolkit-flavored `_cutlass_ir` extension along with its runtime libraries.
    ''
      for wheel in ${coreWheel} ${fetchLibsWheel ctk}; do
        unzip -qq "$wheel" -d "$out/${python.sitePackages}" -x '*.dist-info/*'
      done
    ''
    # `_mlir_libs/__init__.py` locates `libcute_dsl_runtime.so` by walking up to a parent directory
    # named `nvidia_cutlass_dsl`.
    # That walk comes up empty when `cutlass` is imported through the top-level symlink created
    # below, which leaves `CUTE_DSL_LIBS` unset, so point it at the real location instead.
    + ''
      substituteInPlace "$out/${python.sitePackages}/nvidia_cutlass_dsl/dsl_packages/cutlass/_mlir/_mlir_libs/__init__.py" \
        --replace-fail \
          "    nvidia_root = None" \
          "    nvidia_root = Path(\"$out/${python.sitePackages}/nvidia_cutlass_dsl\")"
    ''
    # The wheels ship `cutlass` and `iket` nested under `nvidia_cutlass_dsl/dsl_packages/`, exposed
    # at the top level via `nvidia_cutlass_dsl_packages.pth`.
    # Python only processes `.pth` files in directories registered as site dirs by `site.py`, not in
    # PYTHONPATH entries.
    # In nixpkgs, `buildPythonPackage` propagates dependencies via PYTHONPATH (see python's
    # setup-hook), so any downstream consumer (e.g. flash-attn) would not see the `cutlass` module.
    # `withPackages` envs work fine because they merge everything into a real site dir.
    # Symlinking them to the site-packages root makes them importable in both modes.
    + ''
      for pkg in "$out/${python.sitePackages}"/nvidia_cutlass_dsl/dsl_packages/*; do
        ln -s "nvidia_cutlass_dsl/dsl_packages/$(basename "$pkg")" "$out/${python.sitePackages}/"
      done
    '';

  pythonImportsCheck = [ "cutlass" ];

  # No tests in the Pypi archive
  doCheck = false;

  meta = {
    description = "Bundled MLIR/CUDA runtime libraries and Python sources for the NVIDIA CUTLASS DSL";
    homepage = "https://github.com/NVIDIA/cutlass";
    changelog = "https://github.com/NVIDIA/cutlass/blob/v${version}/CHANGELOG.md";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.nvidiaCutlassDsl;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
  };
}
