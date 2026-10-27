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
  version = "4.8.1";

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
        cp311 = "sha256-BPYNSBXUC4WI3BK8WFcpI2GfG5VHk2GV6AY0qUaMD7I=";
        cp312 = "sha256-rC/Yx/o9be0AkX+ny6hoYGEAXajEcDxqKeA8FQRUOQk=";
        cp313 = "sha256-M02LIZ/5UER55Q74b62qVpWhHyGoflyHp1NUsNa6EPw=";
        cp314 = "sha256-FpQaRNTop2M9vmbT5bZO1ME2E0vxT9V9uEy99XCS5ys=";
      };
      aarch64-linux = {
        cp311 = "sha256-jVG64HLtg89VmoooM11A60Dx/vXgURxAXZ4dpv0rEyA=";
        cp312 = "sha256-xjEviy8ardlZoCdtrzxLrMBceDxuoRGYWe1OvTwH47E=";
        cp313 = "sha256-e8GZoCRBdoSbGpccvDf8QWT3C3Ehp7QmycQr3yQDyxk=";
        cp314 = "sha256-6EscpqE4pPRitAugVUsBf7ztO26CUzNRLZ4bAdZRj4k=";
      };
    };
    cu12 = {
      x86_64-linux = {
        cp311 = "sha256-36i+ILJXv7UKiEOSgncXa2mljsOg/PItfUgl8sOD7YE=";
        cp312 = "sha256-RAuIc5Egxl2WxfFbvklqO9fCY5KHTVr2Bh04SX+Exww=";
        cp313 = "sha256-SdKmQTrvabYGve08S8SBIzVCufk83iQfhpWn6mK08ig=";
        cp314 = "sha256-4h2V54yA9jyQ6wBIFFiZSQbvD3/R60q1eyNCWzjUx6E=";
      };
      aarch64-linux = {
        cp311 = "sha256-cKwOEJGDh+WxsyuzvAjqVlVsTlAMOJ3GiheMXU6Y898=";
        cp312 = "sha256-yJ2f+VdOlFYeF74jwMBtZ/we22pLw+sGfzih3B9oK24=";
        cp313 = "sha256-JJspR/UA0TrsVivVJ8mRNcQ7UgMy2YLwR6hmYefGqSk=";
        cp314 = "sha256-5NPnwH3+nVf4WmI4U7+PDkU85wYTB5vx6b5o2g7weso=";
      };
    };
    cu13 = {
      x86_64-linux = {
        cp311 = "sha256-lpzbjs/oyLUYEAH39IQp991THUPGYJrljr+MkoGFz08=";
        cp312 = "sha256-UBkaOB2MwTkzc64LyHmwrvqaJWwjwi1PocL+Pf5XvJA=";
        cp313 = "sha256-4GN/x+wfEZz4j8QtUAfHf3b1J8uCCSDkdmW8GTt4sL4=";
        cp314 = "sha256-MdfyXJG+4kqXWM1pmmdSafuKWSlTh2ApvujD5Hj3dls=";
      };
      aarch64-linux = {
        cp311 = "sha256-DwqjlOshARNMRKljO+p3ba8xXy/qKrcjzMbJEU+J1+o=";
        cp312 = "sha256-hiN4wMUaOvLgU7NjZWUBsG+aVPd37uW+jABG14C2aVY=";
        cp313 = "sha256-19hf9CHYMTSu8FZz6aRolJ/v2KfMr345AR9b/7mNmJA=";
        cp314 = "sha256-D/KolD4SQ7kzXm0YXOyEHeJzPwwH+FCKVBizv7mEYPk=";
      };
    };
    core = "sha256-usxnYOMobbRH1Fcg0yrlisLmzsreEVI0XveEstXkRDE=";
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
