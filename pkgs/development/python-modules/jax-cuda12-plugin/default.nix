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
        cp312 = "sha256-AJnC2zhcApaVMak7m3deWTInzGFcvPAzNRGlMw+jS5E=";
        cp313 = "sha256-zAmdy2ulBbb4EOcalSdJAM98ggFsO0vMZzJ7wNQOdxw=";
        cp314 = "sha256-XohScLw9JJ8jUsScx/XMTcwxqOH7TQZgxxXdT2T5ySs=";
      };
    };
    aarch64-linux = {
      name = "manylinux_2_27_aarch64";
      hashes = {
        cp312 = "sha256-SUyl21LGJKc8myNc63Vh5mFg7URxNXiozO1N92hmtqg=";
        cp313 = "sha256-nwSWOvjmYVH2CeGcmHBUm2j5aj1tTVxGWgBidEi4TtM=";
        cp314 = "sha256-8LhnY+2IJgmU5fGWbtXrKWmpNAdnXqQysSx20E5/jRQ=";
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
