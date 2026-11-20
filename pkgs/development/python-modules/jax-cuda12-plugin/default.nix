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

  platforms = {
    x86_64-linux = {
      name = "manylinux_2_27_x86_64";
      hashes = {
        cp312 = "sha256-rmekzEmzTFdXE6gxH3WX9nAOxaK2r728PbVVD7Aihzw=";
        cp313 = "sha256-Ve1tvfTW9XxsewqtrrjjNzcaJSSaDjwe+e/LYHsLvGc=";
        cp314 = "sha256-ltGYFX526tkZWHQkZvXHRiYY3SeDHcgjhIgOLoDr5OA=";
      };
    };
    aarch64-linux = {
      name = "manylinux_2_27_aarch64";
      hashes = {
        cp312 = "sha256-rQ+7YFSFhdXw3y/hHrjm1BqYVidO2bw+vi0eHhw9AS8=";
        cp313 = "sha256-KRqt6kpSxTo1+VfKWjwN1TFrXAgvy7UfFkt/INTh1lk=";
        cp314 = "sha256-7H4G16RQgHln81CR1K9sCnJGG9x3xLIXGKUNg3fq6vs=";
      };
    };
  };
  currentPlatform =
    platforms.${stdenv.hostPlatform.system}
      or (throw "jax-cuda12-plugin is not supported on ${stdenv.hostPlatform.system}");

  dist = "cp${lib.replaceStrings [ "." ] [ "" ] python.pythonVersion}";
in
buildPythonPackage {
  pname = "jax-cuda12-plugin";
  inherit version;
  pyproject = false;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "jax_cuda12_plugin";
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

  # jax-cuda12-plugin looks for ptxas at runtime, e.g. with a triton kernel.
  # Linking into $out is the least bad solution. See
  # * https://github.com/NixOS/nixpkgs/pull/164176#discussion_r828801621
  # * https://github.com/NixOS/nixpkgs/pull/288829#discussion_r1493852211
  # * https://github.com/NixOS/nixpkgs/pull/375186
  # for more info.
  postInstall = ''
    export BINPATH="$out/${python.sitePackages}/jax_cuda12_plugin/cuda/bin"
    mkdir -p $BINPATH
    ln -s ${lib.getExe' cudaPackages.cuda_nvcc "ptxas"} $BINPATH/ptxas
    ln -s ${lib.getExe' cudaPackages.cuda_nvcc "nvlink"} $BINPATH/nvlink
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
}
