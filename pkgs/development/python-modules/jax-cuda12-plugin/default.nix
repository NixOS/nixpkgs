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
  inherit (cudaPackages) cudaVersion;
  inherit (jaxlib) version;

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
    "3.10-x86_64-linux" = getSrcFromPypi {
      platform = "manylinux2014_x86_64";
      dist = "cp310";
      hash = "sha256-ymCGSgWlzqRK51dthHtHeeTeYYUKmhgjg0H8Q6dY1Vs=";
    };
    "3.10-aarch64-linux" = getSrcFromPypi {
      platform = "manylinux2014_aarch64";
      dist = "cp310";
      hash = "sha256-488emSaNinBBPw+sM1krh2nBPckdch+RxYeEa+nYhAM=";
    };
    "3.11-x86_64-linux" = getSrcFromPypi {
      platform = "manylinux2014_x86_64";
      dist = "cp311";
      hash = "sha256-NGVbjq/H2b/sMbB3rBPULgjY7YZV0kFHxa38AVFSaU8=";
    };
    "3.11-aarch64-linux" = getSrcFromPypi {
      platform = "manylinux2014_aarch64";
      dist = "cp311";
      hash = "sha256-ik8Mje8QnXb1uqwbKuRpCURFzS1/vYxZf83WI+sC/1Q=";
    };
    "3.12-x86_64-linux" = getSrcFromPypi {
      platform = "manylinux2014_x86_64";
      dist = "cp312";
      hash = "sha256-Fp22Rbr+whOO2YOvjxTk0RqElyivpXIC55qRBNmJLxY=";
    };
    "3.12-aarch64-linux" = getSrcFromPypi {
      platform = "manylinux2014_aarch64";
      dist = "cp312";
      hash = "sha256-wqhtVj3AR5rLTHmuz/vuwYn6vY6XAP4/cxvwOV4dbBE=";
    };
    "3.13-x86_64-linux" = getSrcFromPypi {
      platform = "manylinux2014_x86_64";
      dist = "cp313";
      hash = "sha256-J0kTjLGHMZBoa7FPMxBIskwXjwXkdIo9L/fSA2c1rT0=";
    };
    "3.13-aarch64-linux" = getSrcFromPypi {
      platform = "manylinux2014_aarch64";
      dist = "cp313";
      hash = "sha256-C7aXl3+NbGOS9WLDQF6D68xvXLfCCBQFCE9tXPoJ4yo=";
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

  dependencies = [ jax-cuda12-pjrt ];

  pythonImportsCheck = [ "jax_cuda12_plugin" ];

  # no tests
  doCheck = false;

  meta = {
    description = "JAX Plugin for CUDA12";
    homepage = "https://github.com/jax-ml/jax/tree/main/jax_plugins/cuda";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = lib.platforms.linux;
    # see CUDA compatibility matrix
    # https://jax.readthedocs.io/en/latest/installation.html#pip-installation-nvidia-gpu-cuda-installed-locally-harder
    broken =
      !(lib.versionAtLeast cudaVersion "12.1") || !(lib.versionAtLeast cudaPackages.cudnn.version "9.1");
  };
}
