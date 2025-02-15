{
  lib,
  stdenv,
  buildPythonPackage,
  fetchurl,
  addDriverRunpath,
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
      (lib.getLib cudnn) # libcudnn.so
      (lib.getLib libcublas) # libcublas.so
      addDriverRunpath.driverLink # libcuda.so
    ]
  );

  # Find new releases at https://storage.googleapis.com/jax-releases
  # When upgrading, you can get these hashes from jaxlib/prefetch.sh. See
  # https://github.com/google/jax/issues/12879 as to why this specific URL is the correct index.

  # upstream does not distribute jax-cuda12-pjrt binaries for aarch64-linux
  srcs = {
    "x86_64-linux" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12_plugin/jax_cuda12_pjrt-${version}-py3-none-manylinux2014_x86_64.whl";
      hash = "sha256-0jgzwbiF2WwnZAAOlQUvK1gnx31JLqaPZ+kDoTJlbbs=";
    };
    # "aarch64-linux" = fetchurl {
    #   url = "https://storage.googleapis.com/jax-releases/cuda12_plugin/jax_cuda12_pjrt-${version}-py3-none-manylinux2014_aarch64.whl";
    #   hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    # };
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
    autoPatchelfHook
    pypaInstallHook
    wheelUnpackHook
  ];

  # jax-cuda12-pjrt looks for ptxas, nvlink and nvvm at runtime, eg when running `jax.random.PRNGKey(0)`.
  # Linking into $out is the least bad solution. See
  # * https://github.com/NixOS/nixpkgs/pull/164176#discussion_r828801621
  # * https://github.com/NixOS/nixpkgs/pull/288829#discussion_r1493852211
  # for more info.
  postInstall = ''
    mkdir -p $out/${python.sitePackages}/jax_plugins/nvidia/cuda_nvcc/bin
    ln -s ${lib.getExe' cudaPackages.cuda_nvcc "ptxas"} $out/${python.sitePackages}/jax_plugins/nvidia/cuda_nvcc/bin/ptxas
    ln -s ${lib.getExe' cudaPackages.cuda_nvcc "nvlink"} $out/${python.sitePackages}/jax_plugins/nvidia/cuda_nvcc/bin/nvlink
    ln -s ${cudaPackages.cuda_nvcc}/nvvm $out/${python.sitePackages}/jax_plugins/nvidia/cuda_nvcc/nvvm
  '';

  # jax-cuda12-pjrt contains shared libraries that open other shared libraries via dlopen
  # and these implicit dependencies are not recognized by ldd or
  # autoPatchelfHook. That means we need to sneak them into rpath. This step
  # must be done after autoPatchelfHook and the automatic stripping of
  # artifacts. autoPatchelfHook runs in postFixup and auto-stripping runs in the
  # patchPhase.
  preInstallCheck = ''
    patchelf --add-rpath "${cudaLibPath}" $out/${python.sitePackages}/jax_plugins/xla_cuda12/xla_cuda_plugin.so
  '';

  # FIXME: there are no tests, but we need to run preInstallCheck above
  doCheck = true;

  pythonImportsCheck = [ "jax_plugins" ];

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
      !(lib.versionAtLeast cudaVersion "12.1") || !(lib.versionAtLeast cudaPackages.cudnn.version "9.1");
  };
}
