{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  autoPatchelfHook,
  pypaInstallHook,
  wheelUnpackHook,
  cudaPackages,
  python,
  jaxlib,
  jax-cuda12-pjrt,
}:
let
  inherit (jaxlib) version;
  inherit (jax-cuda12-pjrt) cudaLibPath;

  getSrcFromPypi =
    {
      platform,
      dist,
      hash,
    }:
    fetchPypi {
      inherit
        version
        platform
        dist
        hash
        ;
      pname = "jax_cuda12_plugin";
      format = "wheel";
      python = dist;
      abi = dist;
    };

  # upstream does not distribute jax-cuda12-plugin 0.4.38 binaries for aarch64-linux
  srcs = {
    "3.11-x86_64-linux" = getSrcFromPypi {
      platform = "manylinux_2_27_x86_64";
      dist = "cp311";
      hash = "sha256-lXMXyv8eawBqE1UXM3cN8jWidHBkviawJ0YP46WPWO4=";
    };
    "3.11-aarch64-linux" = getSrcFromPypi {
      platform = "manylinux_2_27_aarch64";
      dist = "cp311";
      hash = "sha256-GkpKVqgyrTDgHBQIWx+iRApV+kzggI5AXnNlDv+K+zE=";
    };
    "3.12-x86_64-linux" = getSrcFromPypi {
      platform = "manylinux_2_27_x86_64";
      dist = "cp312";
      hash = "sha256-oWugDXI2YUWCfKOajISfn+4Rd9ZzjJ7f1ys6n+31zxg=";
    };
    "3.12-aarch64-linux" = getSrcFromPypi {
      platform = "manylinux_2_27_aarch64";
      dist = "cp312";
      hash = "sha256-6vGmGVqg60i0IMcfIrktGXeNlIAkl3yuRkEnnV9sH4E=";
    };
    "3.13-x86_64-linux" = getSrcFromPypi {
      platform = "manylinux_2_27_x86_64";
      dist = "cp313";
      hash = "sha256-7QdNN5Z7zmHBuv3fndCoMCMGwS+QcAylrfo9CP3Uruc=";
    };
    "3.13-aarch64-linux" = getSrcFromPypi {
      platform = "manylinux_2_27_aarch64";
      dist = "cp313";
      hash = "sha256-dHnmfZ2Y1KD1JflPi4GIDcwFhjH23hGLkd6R2xtAle0=";
    };
    "3.14-x86_64-linux" = getSrcFromPypi {
      platform = "manylinux_2_27_x86_64";
      dist = "cp314";
      hash = "sha256-96ahiBNJ3DnyRIGioBn/KUuUkJuAqIge/iHUW2pfaR0=";
    };
    "3.14-aarch64-linux" = getSrcFromPypi {
      platform = "manylinux_2_27_aarch64";
      dist = "cp314";
      hash = "sha256-iIb8V5df7gG+FyX4mLaSkvYVtwgwrvXC+95jgzNha10=";
    };
  };
in
buildPythonPackage {
  pname = "jax-cuda12-plugin";
  inherit version;
  pyproject = false;

  src = (
    srcs."${python.pythonVersion}-${stdenv.hostPlatform.system}"
      or (throw "python${python.pythonVersion}Packages.jax-cuda12-plugin is not supported on ${stdenv.hostPlatform.system}")
  );

  nativeBuildInputs = [
    autoPatchelfHook
    pypaInstallHook
    wheelUnpackHook
  ];

  # jax-cuda12-plugin looks for ptxas at runtime, e.g. with a triton kernel.
  # Linking into $out is the least bad solution. See
  # * https://github.com/NixOS/nixpkgs/pull/164176#discussion_r828801621
  # * https://github.com/NixOS/nixpkgs/pull/288829#discussion_r1493852211
  # * https://github.com/NixOS/nixpkgs/pull/375186
  # for more info.
  postInstall = ''
    mkdir -p $out/${python.sitePackages}/jax_cuda12_plugin/cuda/bin
    ln -s ${lib.getExe' cudaPackages.cuda_nvcc "ptxas"} $out/${python.sitePackages}/jax_cuda12_plugin/cuda/bin
    ln -s ${lib.getExe' cudaPackages.cuda_nvcc "nvlink"} $out/${python.sitePackages}/jax_cuda12_plugin/cuda/bin
  '';

  # jax-cuda12-plugin contains shared libraries that open other shared libraries via dlopen
  # and these implicit dependencies are not recognized by ldd or
  # autoPatchelfHook. That means we need to sneak them into rpath. This step
  # must be done after autoPatchelfHook and the automatic stripping of
  # artifacts. autoPatchelfHook runs in postFixup and auto-stripping runs in the
  # patchPhase.
  preInstallCheck = ''
    patchelf --add-rpath "${cudaLibPath}" $out/${python.sitePackages}/jax_cuda12_plugin/*.so
  '';

  dependencies = [ jax-cuda12-pjrt ];

  pythonImportsCheck = [ "jax_cuda12_plugin" ];

  # FIXME: there are no tests, but we need to run preInstallCheck above
  doCheck = true;

  meta = {
    description = "JAX Plugin for CUDA12";
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
