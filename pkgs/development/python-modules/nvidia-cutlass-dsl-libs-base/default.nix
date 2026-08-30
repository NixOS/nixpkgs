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
  version = "4.7.0";

  inherit (stdenv.hostPlatform) system;

  platform =
    {
      x86_64-linux = "manylinux_2_28_x86_64";
      aarch64-linux = "manylinux_2_28_aarch64";
    }
    .${system} or (throw "nvidia-cutlass-dsl-libs-base is not supported on ${system}");

  pyShortVersion = "cp${builtins.replaceStrings [ "." ] [ "" ] python.pythonVersion}";

  # Which CUDA toolkit flavor of the `_cutlass_ir` extension module to ship. Upstream builds one
  # wheel per CUDA major version and `cutlass/_mlir/_mlir_libs/__init__.py` loads whichever flavors
  # it finds next to itself, picking the newest one the driver supports.
  ctk = "cu${cudaPackages.cudaMajorVersion}";

  hashes = {
    base = {
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
    cu12 = {
      x86_64-linux = {
        cp311 = "sha256-K5C9y6qKkUsB4q/U7wHe30508nuKQRRHsbzd7ODyNRA=";
        cp312 = "sha256-6vhb1gX0H5aMSD3O4a6eE//XZbYj+XaGlAH3fnJVteE=";
        cp313 = "sha256-taZqhEIJN3midHxDpLXHOjVHPGEpk3f9x5CrRVmciN8=";
        cp314 = "sha256-H3fO9u+Irf5Zu6a4ENelt5hjtkz8hLnxqa0CXY/aL1E=";
      };
      aarch64-linux = {
        cp311 = "sha256-67VNL7xFQomdfBMDCET+UxF9mIuxJD1pYv1MqcBu4Jg=";
        cp312 = "sha256-64j30Zcn3z14nnV9srOG+LUrr4LT6zwMUfYegINPXoc=";
        cp313 = "sha256-xzGqNCvnZDqyxm4s2LqrzIYRMWxej0D/s/VON5l2IME=";
        cp314 = "sha256-PGl9TOti6EsA+Yt+PUYiir2mWn9LXlnsKmmOe8h8gro=";
      };
    };
    cu13 = {
      x86_64-linux = {
        cp311 = "sha256-ydXXiFW6zMkXSanIGC6d3+T0/hBlUNhU9E6Ba1cgT80=";
        cp312 = "sha256-Zt2p3RlymDa5GRdLsz1wrviV14XzMg2vzsppVRNAjO8=";
        cp313 = "sha256-uIEEi98AqNUjljjkj8ttNsUCumeLy/cac6VXWQ7cLc8=";
        cp314 = "sha256-hdmvjXR6NAkkM3iOvSLSn6TIgW2npOYfxz/kd9AOVoY=";
      };
      aarch64-linux = {
        cp311 = "sha256-ei9YL0j+oLxyq/OTn7oFJ7+8QjaJMb3o1ooJlumElU8=";
        cp312 = "sha256-sDevu6VLo6HZZQLqcASL7lerWYxj31FY68nw1bHAeQo=";
        cp313 = "sha256-yDH2X68LKDi4Yw8ZW5idM878l7cApXhpHls6nvv9D7s=";
        cp314 = "sha256-SwEISONsTFSyVNKWc7Mbo7JcT7qvpXCLkTaptFLBB7A=";
      };
    };
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
  # end up in a single prefix: as separate derivations, Python would only ever see the portion
  # shipping `cutlass/__init__.py` and the MLIR bindings would be shadowed.
  coreWheel = fetchPypi {
    pname = "nvidia_cutlass_dsl_libs_core";
    inherit version;
    format = "wheel";
    python = "py3";
    dist = "py3";
    hash = "sha256-PGoSjOMUrKPzMuq8sOVaLEw6qVHjNlhKeusrATvtRHQ=";
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
    # named `nvidia_cutlass_dsl`. That walk comes up empty when `cutlass` is imported through the
    # top-level symlink created below, which leaves `CUTE_DSL_LIBS` unset, so point it at the real
    # location instead.
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
    # In nixpkgs, `buildPythonPackage` propagates dependencies via PYTHONPATH
    # (see python's setup-hook), so any downstream consumer (e.g. flash-attn) would not see the
    # `cutlass` module.
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
