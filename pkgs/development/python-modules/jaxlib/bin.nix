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
, cudaPackagesGoogle
}:

let
  inherit (cudaPackagesGoogle) cudatoolkit cudnn;

  version = "0.4.21";

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
        hash = "sha256-mFA/ZSlluDy96Dy7Ez5MyV/onyXOXfwr+v4YBJ8YAKM=";
      };
      "3.9-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp39";
        hash = "sha256-pxFJPKl7LqwRpL0u53zAmp1XvFKPXv0tT/ioQ3EF/Cs=";
      };
      "3.9-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp39";
        hash = "sha256-m8VBotK4tvrEgi8Ub5diHjTv8KU5C384srlSIRcX50o=";
      };

      "3.10-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp310";
        hash = "sha256-jd4+HWPtGt4xLCabVWg99MP+F2bwrhMAJ/BAXfRmIZE=";
      };
      "3.10-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp310";
        hash = "sha256-/zEl2jm9A5iwELPPaSeLlubaFyIkgwdNFzCMKaLvK2A=";
      };
      "3.10-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp310";
        hash = "sha256-BaMQQHdIGtRKDDvjacYLhD7lB058Q8ZYVo6JckVjyxE=";
      };

      "3.11-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp311";
        hash = "sha256-/N41pyv1AOFegCXUH/XmOUiaAfH5/k/ydT8JaFGq+bM=";
      };
      "3.11-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp311";
        hash = "sha256-gYN77bddkBWYQIzPWXusN+xwpga47zSAFdQ4php+AZM=";
      };
      "3.11-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp311";
        hash = "sha256-GaneuQIfERYAcHQtQ6OwL87098QS+h8GrZOfmef0a70=";
      };

      "3.12-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp312";
        hash = "sha256-AkyF07UGTfkQHJ/qN2lHe0ki1Fh1uJZkkGQYRkiTIis=";
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
        hash = "sha256-qGxiVdHNChS5WObW8j9E6G/oEa9FOLRY0/xowQNns0Y=";
      };
      "3.12-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp312";
        hash = "sha256-eYDUrenaHxlCvBYbt12r2VMLBpBBU6o/3ekyj9Ll+AE=";
      };
    };

  # Find new releases at https://storage.googleapis.com/jax-releases/jax_releases.html.
  # When upgrading, you can get these hashes from prefetch.sh. See
  # https://github.com/google/jax/issues/12879 as to why this specific URL is the correct index.
  gpuSrcs = {
    "3.9" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp39-cp39-manylinux2014_x86_64.whl";
      hash = "sha256-VKWX2pTgHWXzbUYXkshmPRxiBs6YDw1WeK72TY1koLc=";
    };
    "3.10" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp310-cp310-manylinux2014_x86_64.whl";
      hash = "sha256-/4wNdMHNT1izYfyX58KH9CAgnQPcv1/GjNlKhFM4X/U=";
    };
    "3.11" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp311-cp311-manylinux2014_x86_64.whl";
      hash = "sha256-xAITc/5KbAiaKp6020OWFD7SL3FQGvE0jQcHckIjb7s=";
    };
    "3.12" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp312-cp312-manylinux2014_x86_64.whl";
      hash = "sha256-tTbpoF/YINx2Vw1JNKsh3PqUbHqQ1XnQLGFczGmimCw=";
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
    broken =
      !(cudaSupport -> (cudaPackagesGoogle ? cudatoolkit) && lib.versionAtLeast cudatoolkit.version "11.1")
      || !(cudaSupport -> (cudaPackagesGoogle ? cudnn) && lib.versionAtLeast cudnn.version "8.2")
      || !(cudaSupport -> stdenv.isLinux);
  };
}
