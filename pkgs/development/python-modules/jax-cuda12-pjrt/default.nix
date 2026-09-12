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

  platforms = {
    x86_64-linux = {
      name = "manylinux_2_27_x86_64";
      hash = "sha256-/dnXJAjhf3ojvfombpyQE2YgpyTfWEYp81BnIuKy9DQ=";
    };
    aarch64-linux = {
      name = "manylinux_2_27_aarch64";
      hash = "sha256-QAIdRVvZRSJwTjIdMOitomp8Cm75XEp1QqvaATiinRw=";
    };
  };
  currentPlatform = platforms.${stdenv.hostPlatform.system};

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
buildPythonPackage (finalAttrs: {
  pname = "jax-cuda12-pjrt";
  inherit version;
  pyproject = false;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "jax_cuda12_pjrt";
    inherit version;
    format = "wheel";
    python = "py3";
    dist = "py3";
    platform = currentPlatform.name;
    inherit (currentPlatform) hash;
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
    export OUTPATH="$out/${python.sitePackages}/jax_plugins/nvidia/cuda_nvcc"
    export BINPATH="$OUTPATH/bin"
    mkdir -p $BINPATH
    ln -s ${lib.getExe' cudaPackages.cuda_nvcc "ptxas"} $BINPATH/ptxas
    ln -s ${lib.getExe' cudaPackages.cuda_nvcc "nvlink"} $BINPATH/nvlink
    ln -s ${cudaPackages.cuda_nvcc}/nvvm $OUTPATH/nvvm
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

  passthru = {
    inherit cudaLibPath;
  };

  meta = {
    description = "JAX XLA PJRT Plugin for NVIDIA GPUs";
    homepage = "https://github.com/jax-ml/jax/tree/main/jax_plugins/cuda";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.asl20;
    teams = [ lib.teams.cuda ];
    maintainers = with lib.maintainers; [
      GaetanLepage
      natsukium
    ];
    platforms = lib.attrNames platforms;
    problems =
      lib.optionalAttrs (cudaPackages.cudaMajorVersion != "12") {
        unsupported-cuda-version = {
          message = ''
            Incompatible cudaPackages version.
              - Expected: 12
              - Got: ${cudaPackages.cudaMajorVersion}
          '';
          kind = "broken";
        };
      }
      // lib.optionalAttrs (lib.versionAtLeast cudaPackages.cudnn.version "10.0") {
        unsupported-cudnn-version = {
          message = ''
            cudaPackages.cudnn is too new (${cudaPackages.cudnn.version}).

            See CUDA compatibility matrix
            https://docs.jax.dev/en/latest/installation.html#pip-installation-nvidia-gpu-cuda-installed-locally-harder
          '';
          kind = "broken";
        };
      };
  };
})
