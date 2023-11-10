# For the moment we only support the CPU and GPU backends of jaxlib. The TPU
# backend will require some additional work. Those wheels are located here:
# https://storage.googleapis.com/jax-releases/libtpu_releases.html.

# For future reference, the easiest way to test the GPU backend is to run
#   NIX_PATH=.. nix-shell -p python3 python3Packages.jax "python3Packages.jaxlib-bin.override { cudaSupport = true; }"
#   export XLA_FLAGS=--xla_gpu_force_compilation_parallelism=1
#   python -c "from jax.lib import xla_bridge; assert xla_bridge.get_backend().platform == 'gpu'"
#   python -c "from jax import random; random.PRNGKey(0)"
#   python -c "from jax import random; x = random.normal(random.PRNGKey(0), (100, 100)); x @ x"
# There's no convenient way to test the GPU backend in the derivation since the
# nix build environment blocks access to the GPU. See also:
#   * https://github.com/google/jax/issues/971#issuecomment-508216439
#   * https://github.com/google/jax/issues/5723#issuecomment-913038780

{ absl-py
, addOpenGLRunpath
, autoPatchelfHook
, buildPythonPackage
, config
, fetchPypi
, fetchurl
, flatbuffers
, jaxlib-build
, lib
, ml-dtypes
, python
, scipy
, stdenv
  # Options:
, cudaSupport ? config.cudaSupport
, cudaPackages ? {}
}:

let
  inherit (cudaPackages) cudatoolkit cudnn;
in

assert cudaSupport -> lib.versionAtLeast cudatoolkit.version "11.1" && lib.versionAtLeast cudnn.version "8.2" && stdenv.isLinux;

let
  version = "0.4.19";

  inherit (python) pythonVersion;

  # As of 2023-06-06, google/jax upstream is no longer publishing CPU-only wheels to their GCS bucket. Instead the
  # official instructions recommend installing CPU-only versions via PyPI.
  cpuSrcs =
    let
      getSrcFromPypi = { platform, dist, hash }: fetchPypi {
        inherit version platform dist hash;
        pname = "jaxlib";
        format = "wheel";
        # See the `disabled` attr comment below.
        python = dist;
        abi = dist;
      };
    in
    {
      "3.9-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp39";
        hash = "sha256-8bTrWutuK0qVnbkcwMfgBf414YdaLc3GK5IsCm/JNPE=";
      };
      "3.9-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp39";
        hash = "sha256-Tmv2iOqlNbZqw/rYjef6GmM0N18EA5JTt6T3lQe+4Rs=";
      };
      "3.9-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp39";
        hash = "sha256-mDT1INLqPdCkxtMMFR0qHLOIZdWEy8Iuzw1/vOoECsA=";
      };

      "3.10-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp310";
        hash = "sha256-ksnY+CPEstact5lKjbSg+ZSPJtSt0Y0NFWEFufBCByk=";
      };
      "3.10-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp310";
        hash = "sha256-O7dHvdKLKfNELGfF4TKy7N5EX6Ca7Zu8OtLXWvFykR8=";
      };
      "3.10-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp310";
        hash = "sha256-gqKMUZSXrt8sQtTAoQbzAfCzO8gM9Y1/tZpuJVWyN0Y=";
      };

      "3.11-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp311";
        hash = "sha256-m+NDzwXMNboNjDl2nLY+vqAoN2dQJZVWb1UQDpqqDPw=";
      };
      "3.11-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp311";
        hash = "sha256-zCOAjaWWCQT9Jnm1jjc1Rh5gemqy7ACtTKLM0MqSJzM=";
      };
      "3.11-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp311";
        hash = "sha256-gOLIxkk+2hew2GqWu1WgMVEx1YEutx7Zod7QbwsuUVQ=";
      };

      "3.12-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp312";
        hash = "sha256-BZTmkgNuV4nWtfbY4t/19aP43szZQEdgpFXh5qwGRXk=";
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
        hash = "sha256-aAMTrLXU9EYwPv+kdeyI88/D7b4NANB39Fn8vuXUqFA=";
      };
      "3.12-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp312";
        hash = "sha256-KHzlIfa9KtYcHX+i/F/SKaYTpD4/XjHVu5j3BdRTUmc=";
      };
    };

  # Find new releases at https://storage.googleapis.com/jax-releases/jax_releases.html.
  # When upgrading, you can get these hashes from prefetch.sh. See
  # https://github.com/google/jax/issues/12879 as to why this specific URL is the correct index.
  gpuSrcs = {
    "3.9" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp39-cp39-manylinux2014_x86_64.whl";
      hash = "sha256-WB5Vbr/XeYKXCP/3DIXF20jR6/1xE3huX1h5ow8ETl0=";
    };
    "3.10" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp310-cp310-manylinux2014_x86_64.whl";
      hash = "sha256-zfN0n31+5GohwBkeQrqHus4qOyhM/GEdqG6KUupCZ4o=";
    };
    "3.11" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp311-cp311-manylinux2014_x86_64.whl";
      hash = "sha256-Q8ZtF2GCrG30GFbCeCZTWPmW2TBybeXzh2u+NRiYpx4=";
    };
    "3.12" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp312-cp312-manylinux2014_x86_64.whl";
      hash = "sha256-lphkSDOJ9SwbO0hp/xC1bYn5fWgth9A9Iwsc9zV0buI=";
    };
  };

in
buildPythonPackage {
  pname = "jaxlib";
  inherit version;
  format = "wheel";

  disabled = !(pythonVersion == "3.9" || pythonVersion == "3.10" || pythonVersion == "3.11" || pythonVersion == "3.12");

  # See https://discourse.nixos.org/t/ofborg-does-not-respect-meta-platforms/27019/6.
  src =
    if !cudaSupport then
      (
        cpuSrcs."${pythonVersion}-${stdenv.hostPlatform.system}"
          or (throw "jaxlib-bin is not supported on ${stdenv.hostPlatform.system}")
      ) else gpuSrcs."${pythonVersion}";

  # Prebuilt wheels are dynamically linked against things that nix can't find.
  # Run `autoPatchelfHook` to automagically fix them.
  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ]
    ++ lib.optionals cudaSupport [ addOpenGLRunpath ];
  # Dynamic link dependencies
  buildInputs = [ stdenv.cc.cc.lib ];

  # jaxlib contains shared libraries that open other shared libraries via dlopen
  # and these implicit dependencies are not recognized by ldd or
  # autoPatchelfHook. That means we need to sneak them into rpath. This step
  # must be done after autoPatchelfHook and the automatic stripping of
  # artifacts. autoPatchelfHook runs in postFixup and auto-stripping runs in the
  # patchPhase. Dependencies:
  #   * libcudart.so.11.0 -> cudatoolkit_11.lib
  #   * libcublas.so.11   -> cudatoolkit_11
  #   * libcuda.so.1      -> opengl driver in /run/opengl-driver/lib
  preInstallCheck = lib.optional cudaSupport ''
    shopt -s globstar

    addOpenGLRunpath $out/**/*.so

    for file in $out/**/*.so; do
      rpath=$(patchelf --print-rpath $file)
      # For some reason `makeLibraryPath` on `cudatoolkit_11` maps to
      # <cudatoolkit_11.lib>/lib which is different from <cudatoolkit_11>/lib.
      patchelf --set-rpath "$rpath:${cudatoolkit}/lib:${lib.makeLibraryPath [ cudatoolkit.lib cudnn ]}" $file
    done
  '';

  propagatedBuildInputs = [
    absl-py
    flatbuffers
    ml-dtypes
    scipy
  ];

  # Note that cudatoolkit is snecessary since jaxlib looks for "ptxas" in $PATH.
  # See https://github.com/NixOS/nixpkgs/pull/164176#discussion_r828801621 for
  # more info.
  postInstall = lib.optional cudaSupport ''
    mkdir -p $out/bin
    ln -s ${cudatoolkit}/bin/ptxas $out/bin/ptxas
  '';

  inherit (jaxlib-build) pythonImportsCheck;

  meta = with lib; {
    description = "XLA library for JAX";
    homepage = "https://github.com/google/jax";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
    platforms = [ "aarch64-darwin" "x86_64-linux" "x86_64-darwin" ];
  };
}
