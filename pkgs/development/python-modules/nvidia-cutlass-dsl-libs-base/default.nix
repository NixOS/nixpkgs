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
  version = "4.7.1";

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
        cp311 = "sha256-Qx42SLhK1KgajTsfp+RFMmy1pSTmT2witNGRp2RVvfk=";
        cp312 = "sha256-wrZ9rKv8kF5NEyeE/khIZH9AsLl7HN3jzkpIJkJTa4Q=";
        cp313 = "sha256-YQl8XDVeHkL4Ux79To6tC6Ya4atrC5rPy/LKZls9rlo=";
        cp314 = "sha256-B3ZQb2ZuHGg0qKkZXvICmXM64BPSNHJoKVZb5dhQmUI=";
      };
      aarch64-linux = {
        cp311 = "sha256-KY5zrQ8bBITkuEOOnarjhzKmytyfQCNHXlsMKGiYWro=";
        cp312 = "sha256-6GxVpQEKft/AZ2SKdcsp0MW9Z9dSEBaM9Qew0OTRW6c=";
        cp313 = "sha256-BmWOaR6xBHyDvki6UBv3Py6n7N2MHuX58m21h5COQ+0=";
        cp314 = "sha256-NhkrTQ9yxPR7Od7yD0/acQWABWF7cgQ5VXB2iCdSSYI=";
      };
    };
    cu12 = {
      x86_64-linux = {
        cp311 = "sha256-83/L2UqtZrAW3OpIPbUN2w/Kq3EwxTjfIO8p3e64uoU=";
        cp312 = "sha256-yKD5OhzeQUBGlrMZTdH1icbzp7QmvKvpeEX4/pb5SfU=";
        cp313 = "sha256-s0qTPN4eXPLfHzz9eO+9VITqM90Ml74gHAV+For3nBA=";
        cp314 = "sha256-BvU99K2hQEO0WZk6bcRp0FBa2aFE0QG19ARhpYqOgOM=";
      };
      aarch64-linux = {
        cp311 = "sha256-SdVW8r4YjXWBD6jFR60V26QGhROKwn1UQYRBgqxJVak=";
        cp312 = "sha256-9Xo5VcF7fc1UcqpHxGUT5fORThMl/DCK/KG5BjqPiXs=";
        cp313 = "sha256-d2hKhhkRlbLW619wiLub8l5F21jOtEqcAv+weHu5X7k=";
        cp314 = "sha256-03CLeLm3DcGynJpIpwMNFKGowXtS8/LQiNs9c8YDvsg=";
      };
    };
    cu13 = {
      x86_64-linux = {
        cp311 = "sha256-gT7hn4yLbTkoSiSumd2am0lrM8mScLLPlUjnn0kXhAU=";
        cp312 = "sha256-IMFOFhJcuONryZR6nwpXpmD0RlE2Uze5EchKveSWf18=";
        cp313 = "sha256-L4b+jRp+9RC4U6OADL8yRAGhL9x3DMz0rF4gqdDH0b0=";
        cp314 = "sha256-Z9NjqWA869uEdpi8b8GLwUupT1wPRcILETijFuBox74=";
      };
      aarch64-linux = {
        cp311 = "sha256-eq9DgKM4rjbFNRL2a4lHDebuHwTzgWOonNJebe6S/oc=";
        cp312 = "sha256-5nW/BNxskffE1VQGmbegMfK4tEzSaHsywgiS8RL34Nk=";
        cp313 = "sha256-odI870RnXmOCXD9ddz57QiiALKFV6rYcC8XlUcrzWtI=";
        cp314 = "sha256-QlZ2czwaF1Hl/U/E3dTsb75nYNYxzhLtKH3WPPjDZG4=";
      };
    };
    core = "sha256-xlZiq8mrGP2ZfFdUeJVzaSjlWfRiS74qoaqRQY6gFMo=";
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
    hash = "sha256-xlZiq8mrGP2ZfFdUeJVzaSjlWfRiS74qoaqRQY6gFMo=";
  };
in
buildPythonPackage {
  pname = "nvidia-cutlass-dsl-libs-base";
  inherit version;
  format = "wheel";
  __structuredAttrs = true;

  src = fetchLibsWheel "base";

  pythonRemoveDeps = [
    # Only cuda-bindings is needed
    "cuda-python"

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
    license = lib.licenses.unfreeRedistributable; # NVIDIA Proprietary
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
  };
}
