{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
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

  cudaLibPath = lib.makeLibraryPath (
    with cudaPackages;
    [
      (lib.getLib libcublas) # libcublas.so
      (lib.getLib cuda_cupti) # libcupti.so
      (lib.getLib cuda_cudart) # libcudart.so
      (lib.getLib cudnn) # libcudnn.so
      (lib.getLib libcufft) # libcufft.so
      (lib.getLib libcusolver) # libcusolver.so
      (lib.getLib libcusparse) # libcusparse.so
      (lib.getLib nccl) # libnccl.so
      (lib.getLib libnvjitlink) # libnvJitLink.so
      (lib.getLib addDriverRunpath.driverLink) # libcuda.so
    ]
  );

in
buildPythonPackage rec {
  pname = "jax-cuda12-pjrt";
  inherit version;
  pyproject = false;

  src = fetchPypi {
    pname = "jax_cuda12_pjrt";
    inherit version;
    format = "wheel";
    python = "py3";
    dist = "py3";
    platform =
      {
        x86_64-linux = "manylinux_2_27_x86_64";
        aarch64-linux = "manylinux_2_27_aarch64";
      }
      .${stdenv.hostPlatform.system};
    hash =
      {
        x86_64-linux = "sha256-RStw7hDLmsXX38pV/7zbibbIvGunCkWvfEkNHc6pjrc=";
        aarch64-linux = "sha256-pjHQaJkDNUr9ez0uxZW32gamIwp22gD/lUj1QrIbYlA=";
      }
      .${stdenv.hostPlatform.system};
  };

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

  inherit cudaLibPath;

  meta = {
    description = "JAX XLA PJRT Plugin for NVIDIA GPUs";
    homepage = "https://github.com/jax-ml/jax/tree/main/jax_plugins/cuda";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = lib.platforms.linux;
    # see CUDA compatibility matrix
    # https://jax.readthedocs.io/en/latest/installation.html#pip-installation-nvidia-gpu-cuda-installed-locally-harder
    broken = !(lib.versionAtLeast cudaPackages.cudnn.version "9.1");
  };
}
