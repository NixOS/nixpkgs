{
  lib,
  stdenv,
  buildPythonPackage,
  fetchurl,
  autoAddDriverRunpath,
  autoPatchelfHook,
  pypaInstallHook,
  wheelUnpackHook,
  cudaPackages,
  python,
  jaxlib,
}:
let
  inherit (jaxlib) version;
  inherit (cudaPackages) cudaVersion;

  cudaLibPath = lib.makeLibraryPath (
    with cudaPackages;
    [
      (lib.getLib cuda_cudart) # libcudart.so
      (lib.getLib cuda_cupti) # libcupti.so
      (lib.getLib cudnn) # libcudnn.so
      (lib.getLib libcufft) # libcufft.so
      (lib.getLib libcusolver) # libcusolver.so
      (lib.getLib libcusparse) # libcusparse.so
    ]
  );

  # Find new releases at https://storage.googleapis.com/jax-releases
  # When upgrading, you can get these hashes from prefetch.sh. See
  # https://github.com/google/jax/issues/12879 as to why this specific URL is the correct index.

  # upstream does not distribute jax-cuda12-pjrt 0.4.38 binaries for aarch64-linux
  srcs = {
    "x86_64-linux" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12_plugin/jax_cuda12_pjrt-${version}-py3-none-manylinux2014_x86_64.whl";
      hash = "sha256-g75MWfvPMAd6YAhdmOfVncc4sckeDWKOSsF3n94VrCs=";
    };
    "aarch64-linux" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12_plugin/jax_cuda12_pjrt-${version}-py3-none-manylinux2014_aarch64.whl";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };
  };
in
buildPythonPackage {
  pname = "jax-cuda12-pjrt";
  inherit version;
  pyproject = false;

  src =
    srcs.${stdenv.hostPlatform.system}
      or (throw "jax-cuda12-pjrt: No src for ${stdenv.hostPlatform.system}");

  nativeBuildInputs = [
    autoAddDriverRunpath
    autoPatchelfHook
    pypaInstallHook
    wheelUnpackHook
  ];

  # The following attributes (buildInputs, postInstall and preInstallCheck) are copied from jaxlib-0.4.28
  # but it does not recognize GPUs as of 2024-12-29
  # Dynamic link dependencies
  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  # jaxlib looks for ptxas at runtime, eg when running `jax.random.PRNGKey(0)`.
  # Linking into $out is the least bad solution. See
  # * https://github.com/NixOS/nixpkgs/pull/164176#discussion_r828801621
  # * https://github.com/NixOS/nixpkgs/pull/288829#discussion_r1493852211
  # for more info.
  postInstall = ''
    mkdir -p $out/${python.sitePackages}/jaxlib/cuda/bin
    ln -s ${lib.getExe' cudaPackages.cuda_nvcc "ptxas"} $out/${python.sitePackages}/jaxlib/cuda/bin/ptxas
  '';

  # jaxlib contains shared libraries that open other shared libraries via dlopen
  # and these implicit dependencies are not recognized by ldd or
  # autoPatchelfHook. That means we need to sneak them into rpath. This step
  # must be done after autoPatchelfHook and the automatic stripping of
  # artifacts. autoPatchelfHook runs in postFixup and auto-stripping runs in the
  # patchPhase.
  preInstallCheck = ''
    shopt -s globstar

    for file in $out/**/*.so; do
      echo $file
      patchelf --add-rpath "${cudaLibPath}" "$file"
    done
  '';

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "jax_plugins.xla_cuda12" ];

  meta = {
    description = "JAX XLA PJRT Plugin for NVIDIA GPUs";
    homepage = "https://github.com/jax-ml/jax/tree/main/jax_plugins/cuda";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = lib.attrNames srcs;
    # see CUDA compatibility matrix
    # https://jax.readthedocs.io/en/latest/installation.html#pip-installation-nvidia-gpu-cuda-installed-locally-harder
    broken =
      !(lib.versionAtLeast cudaVersion "12.1")
      || !(lib.versionAtLeast cudaPackages.cudnn.version "9.1")
      || true;
  };
}
