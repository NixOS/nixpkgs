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

{ addOpenGLRunpath, autoPatchelfHook, buildPythonPackage, config
, fetchurl, isPy39, lib, stdenv
# propagatedBuildInputs
, absl-py, flatbuffers, scipy, cudatoolkit_11
# Options:
, cudaSupport ? config.cudaSupport or false
}:

assert cudaSupport -> lib.versionAtLeast cudatoolkit_11.version "11.1";

let
  device = if cudaSupport then "gpu" else "cpu";
in
buildPythonPackage rec {
  pname = "jaxlib";
  version = "0.1.71";
  format = "wheel";

  # At the time of writing (8/19/21), there are releases for 3.7-3.9. Supporting
  # all of them is a pain, so we focus on 3.9, the current nixpkgs python3
  # version.
  disabled = !isPy39;

  src = {
    cpu = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/nocuda/jaxlib-${version}-cp39-none-manylinux2010_x86_64.whl";
      sha256 = "sha256:0rqhs6qabydizlv5d3rb20dbv6612rr7dqfniy9r6h4kazdinsn6";
    };
    gpu = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda111/jaxlib-${version}+cuda111-cp39-none-manylinux2010_x86_64.whl";
      sha256 = "sha256:065kyzjsk9m84d138p99iymdiiicm1qz8a3iwxz8rspl43rwrw89";
    };
  }.${device};

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
      patchelf --set-rpath "$rpath:${cudatoolkit_11}/lib:${lib.makeLibraryPath [ cudatoolkit_11.lib ]}" $file
    done
  '';

  # pip dependencies and optionally cudatoolkit.
  propagatedBuildInputs = [ absl-py flatbuffers scipy ] ++ lib.optional cudaSupport cudatoolkit_11;

  pythonImportsCheck = [ "jaxlib" ];

  meta = with lib; {
    description = "XLA library for JAX";
    homepage    = "https://github.com/google/jax";
    license     = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
    platforms = [ "x86_64-linux" ];
  };
}
