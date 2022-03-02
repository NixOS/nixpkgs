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
, scipy
, stdenv
  # Options:
, cudaSupport ? config.cudaSupport or false
}:

# Note that these values are tied to the specific version of the GPU wheel that
# we fetch. When updating, try to go for the latest possible versions that are
# still compatible with the cudatoolkit and cudnn versions available in nixpkgs.
assert cudaSupport -> lib.versionAtLeast cudatoolkit_11.version "11.1";
assert cudaSupport -> lib.versionAtLeast cudnn.version "8.0.5";

let
  device = if cudaSupport then "gpu" else "cpu";
in
buildPythonPackage rec {
  pname = "jaxlib";
  version = "0.3.0";
  format = "wheel";

  # At the time of writing (8/19/21), there are releases for 3.7-3.9. Supporting
  # all of them is a pain, so we focus on 3.9, the current nixpkgs python3
  # version.
  disabled = !isPy39;

  # Find new releases at https://storage.googleapis.com/jax-releases.
  src = {
    cpu = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/nocuda/jaxlib-${version}-cp39-none-manylinux2010_x86_64.whl";
      sha256 = "151p4vqli8x0iqgrzrr8piqk7d76a2xq2krf23jlb142iam5bw01";
    };
    gpu = fetchurl {
      # Note that there's also a release targeting cuDNN 8.2, but unfortunately
      # we don't yet have that packaged at the time of writing (02/03/2022).
      # Check pkgs/development/libraries/science/math/cudnn/default.nix for more
      # details.
      url = "https://storage.googleapis.com/jax-releases/cuda11/jaxlib-${version}+cuda11.cudnn805-cp39-none-manylinux2010_x86_64.whl";
      sha256 = "0z15rdw3a8sq51rpjmfc41ix1q095aasl79rvlib85ir6f3wh2h8";

      # This is what the cuDNN 8.2 download looks like for future reference:
      # url = "https://storage.googleapis.com/jax-releases/cuda11/jaxlib-${version}+cuda11.cudnn82-cp39-none-manylinux2010_x86_64.whl";
      # sha256 = "000mnm2masm3sx3haddcmgw43j4gxa3m4fcm14p9nb8dnncjkgpb";
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
