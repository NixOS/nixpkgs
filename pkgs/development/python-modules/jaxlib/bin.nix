# For the moment we only support the CPU and GPU backends of jaxlib. The TPU
# backend will require some additional work. Those wheels are located here:
# https://storage.googleapis.com/jax-releases/libtpu_releases.html.

# For future reference, the easiest way to test the GPU backend is to run
#   NIX_PATH=.. nix-shell -p python3 python3Packages.jax "python3Packages.jaxlib.override { cudaSupport = true; }"
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
, cudatoolkit_11
, cudnn
, fetchurl
, flatbuffers
, isPy39
, lib
, python
, scipy
, stdenv
  # Options:
, cudaSupport ? config.cudaSupport or false
}:

# There are no jaxlib wheels targeting cudnn <8.0.5, and although there are
# wheels for cudatoolkit <11.1, we don't support them.
assert cudaSupport -> lib.versionAtLeast cudatoolkit_11.version "11.1";
assert cudaSupport -> lib.versionAtLeast cudnn.version "8.0.5";

let
  version = "0.3.0";

  pythonVersion = python.pythonVersion;

  # Find new releases at https://storage.googleapis.com/jax-releases. When
  # upgrading, you can get these hashes from prefetch.sh.
  cpuSrcs = {
    "3.9" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/nocuda/jaxlib-${version}-cp39-none-manylinux2010_x86_64.whl";
      hash = "sha256-AfBVqoqChEXlEC5PgbtQ5rQzcbwo558fjqCjSPEmN5Q=";
    };
    "3.10" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/nocuda/jaxlib-${version}-cp310-none-manylinux2010_x86_64.whl";
      hash = "sha256-9uBkFOO8LlRpO6AP+S8XK9/d2yRdyHxQGlbAjShqHRQ=";
    };
  };

  gpuSrcs = {
    "3.9-805" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda11/jaxlib-${version}+cuda11.cudnn805-cp39-none-manylinux2010_x86_64.whl";
      hash = "sha256-CArIhzM5FrQi3TkdqpUqCeDQYyDMVXlzKFgjNXjLJXw=";
    };
    "3.9-82" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda11/jaxlib-${version}+cuda11.cudnn82-cp39-none-manylinux2010_x86_64.whl";
      hash = "sha256-Q0plVnA9pUNQ+gCHSXiLNs4i24xCg8gBGfgfYe3bot4=";
    };
    "3.10-805" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda11/jaxlib-${version}+cuda11.cudnn805-cp310-none-manylinux2010_x86_64.whl";
      hash = "sha256-JopevCEAs0hgDngIId6NqbLam5YfcS8Lr9cEffBKp1U=";
    };
    "3.10-82" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda11/jaxlib-${version}+cuda11.cudnn82-cp310-none-manylinux2010_x86_64.whl";
      hash = "sha256-2f5TwbdP7EfQNRM3ZcJXCAkS2VXBwNYH6gwT9pdu3Go=";
    };
  };
in
buildPythonPackage rec {
  pname = "jaxlib";
  inherit version;
  format = "wheel";

  # At the time of writing (2022-03-03), there are releases for <=3.10.
  # Supporting all of them is a pain, so we focus on 3.9, the current nixpkgs
  # python3 version, and 3.10.
  disabled = !(pythonVersion == "3.9" || pythonVersion == "3.10");

  src =
    if !cudaSupport then cpuSrcs."${pythonVersion}" else
    let
      # jaxlib wheels are currently provided for cudnn versions at least 8.0.5 and
      # 8.2. Try to use 8.2 whenever possible.
      cudnnVersion = if (lib.versionAtLeast cudnn.version "8.2") then "82" else "805";
    in
    gpuSrcs."${pythonVersion}-${cudnnVersion}";

  # Prebuilt wheels are dynamically linked against things that nix can't find.
  # Run `autoPatchelfHook` to automagically fix them.
  nativeBuildInputs = [ autoPatchelfHook ] ++ lib.optional cudaSupport addOpenGLRunpath;
  # Dynamic link dependencies
  buildInputs = [ stdenv.cc.cc ];

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
      patchelf --set-rpath "$rpath:${cudatoolkit_11}/lib:${lib.makeLibraryPath [ cudatoolkit_11.lib cudnn ]}" $file
    done
  '';

  # pip dependencies and optionally cudatoolkit. Note that cudatoolkit is
  # necessary since jaxlib looks for "ptxas" in $PATH.
  propagatedBuildInputs = [ absl-py flatbuffers scipy ] ++ lib.optional cudaSupport cudatoolkit_11;

  pythonImportsCheck = [ "jaxlib" ];

  meta = with lib; {
    description = "XLA library for JAX";
    homepage = "https://github.com/google/jax";
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
    platforms = [ "x86_64-linux" ];
  };
}
