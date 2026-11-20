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
  jax-cuda13-pjrt,
}:
let
  inherit (jaxlib) version;
  inherit (jax-cuda13-pjrt) cudaLibPath;

  platforms = {
    x86_64-linux = {
      name = "manylinux_2_27_x86_64";
      hashes = {
        cp312 = "sha256-rTU+0YdyYQVg36KNXhVNntN3/SVyggpI9bVZEDe4eQk=";
        cp313 = "sha256-l5aBOt4ZkL18neR1ubqmqidclzYSOQEb/DICKXZvLV4=";
        cp314 = "sha256-hMDOpE60Ju825kzR3RRhmauiFWFyMSOQlpBHwmvM7qM=";
      };
    };
    aarch64-linux = {
      name = "manylinux_2_27_aarch64";
      hashes = {
        cp312 = "sha256-AWY4p5REkWPKnN1ZvMvQ44AovyjnMhfLlryLFCpbjOI=";
        cp313 = "sha256-TIhgusB4zeTetWV6o4l7A5lM/GYngGiUc1QPL+89Nzw=";
        cp314 = "sha256-P0ZWPnmhGL359m+VmMeFrjxtIX74NPE4Qx6OdCZDlPM=";
      };
    };
  };
  currentPlatform =
    platforms.${stdenv.hostPlatform.system}
      or (throw "jax-cuda13-plugin is not supported on ${stdenv.hostPlatform.system}");

  dist = "cp${lib.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
in
buildPythonPackage {
  pname = "jax-cuda13-plugin";
  inherit version;
  pyproject = false;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "jax_cuda13_plugin";
    inherit version dist;
    format = "wheel";
    python = dist;
    abi = dist;
    platform = currentPlatform.name;
    hash =
      currentPlatform.hashes.${dist}
        or (throw "python${python.pythonVersion}Packages.jax-cuda12-plugin is not supported");
  };

  nativeBuildInputs = [
    autoPatchelfHook
    pypaInstallHook
    wheelUnpackHook
  ];

  # jax-cuda13-plugin looks for ptxas at runtime, e.g. with a triton kernel.
  # Linking into $out is the least bad solution. See
  # * https://github.com/NixOS/nixpkgs/pull/164176#discussion_r828801621
  # * https://github.com/NixOS/nixpkgs/pull/288829#discussion_r1493852211
  # * https://github.com/NixOS/nixpkgs/pull/375186
  # for more info.
  postInstall = ''
    export BINPATH="$out/${python.sitePackages}/jax_cuda13_plugin/cuda/bin"
    mkdir -p $BINPATH
    ln -s ${lib.getExe' cudaPackages.cuda_nvcc "ptxas"} $BINPATH
    ln -s ${lib.getExe' cudaPackages.cuda_nvcc "nvlink"} $BINPATH
  '';

  # jax-cuda12-plugin contains shared libraries that open other shared libraries via dlopen
  # and these implicit dependencies are not recognized by ldd or
  # autoPatchelfHook. That means we need to sneak them into rpath. This step
  # must be done after autoPatchelfHook and the automatic stripping of
  # artifacts. autoPatchelfHook runs in postFixup and auto-stripping runs in the
  # patchPhase.
  preInstallCheck = ''
    patchelf --add-rpath "${cudaLibPath}" $out/${python.sitePackages}/jax_cuda13_plugin/*.so
  '';

  dependencies = [ jax-cuda13-pjrt ];

  pythonImportsCheck = [ "jax_cuda13_plugin" ];

  # FIXME: there are no tests, but we need to run preInstallCheck above
  doCheck = true;

  meta = {
    description = "JAX Plugin for CUDA13";
    homepage = "https://github.com/jax-ml/jax/tree/main/jax_plugins/cuda";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.asl20;
    teams = [ lib.teams.cuda ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.attrNames platforms;
    problems =
      lib.optionalAttrs (cudaPackages.cudaMajorVersion != "13") {
        unsupported-cuda-version = {
          message = ''
            Incompatible cudaPackages version.
              - Expected: 13
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
}
