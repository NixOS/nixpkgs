# For the moment we only support the CPU and GPU backends of jaxlib. The TPU
# backend will require some additional work. Those wheels are located here:
# https://storage.googleapis.com/jax-releases/libtpu_releases.html.

# See `python3Packages.jax.passthru` for CUDA tests.

{
  absl-py,
  autoAddDriverRunpath,
  autoPatchelfHook,
  buildPythonPackage,
  config,
  fetchPypi,
  fetchurl,
  flatbuffers,
  jaxlib-build,
  lib,
  ml-dtypes,
  python,
  scipy,
  stdenv,
  # Options:
  cudaSupport ? config.cudaSupport,
  cudaPackages,
}:

let
  inherit (cudaPackages) cudaVersion;

  version = "0.4.28";

  inherit (python) pythonVersion;

  cudaLibPath = lib.makeLibraryPath (
    with cudaPackages;
    [
      cuda_cudart.lib # libcudart.so
      cuda_cupti.lib # libcupti.so
      cudnn.lib # libcudnn.so
      libcufft.lib # libcufft.so
      libcusolver.lib # libcusolver.so
      libcusparse.lib # libcusparse.so
    ]
  );

  # As of 2023-06-06, google/jax upstream is no longer publishing CPU-only wheels to their GCS bucket. Instead the
  # official instructions recommend installing CPU-only versions via PyPI.
  cpuSrcs =
    let
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
          pname = "jaxlib";
          format = "wheel";
          # See the `disabled` attr comment below.
          python = dist;
          abi = dist;
        };
    in
    {
      "3.9-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp39";
        hash = "sha256-Slbr8FtKTBeRaZ2HTgcvP4CPCYa0AQsU+1SaackMqdw=";
      };
      "3.9-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp39";
        hash = "sha256-sBVi7IrXVxm30DiXUkiel+trTctMjBE75JFjTVKCrTw=";
      };
      "3.9-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp39";
        hash = "sha256-T5jMg3srbG3P4Kt/+esQkxSSCUYRmqOvn6oTlxj/J4c=";
      };

      "3.10-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp310";
        hash = "sha256-47zcb45g+FVPQVwU2TATTmAuPKM8OOVGJ0/VRfh1dps=";
      };
      "3.10-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp310";
        hash = "sha256-8Djmi9ENGjVUcisLvjbmpEg4RDenWqnSg/aW8O2fjAk=";
      };
      "3.10-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp310";
        hash = "sha256-pCHSN/jCXShQFm0zRgPGc925tsJvUrxJZwS4eCKXvWY=";
      };

      "3.11-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp311";
        hash = "sha256-Rc4PPIQM/4I2z/JsN/Jsn/B4aV+T4MFiwyDCgfUEEnU=";
      };
      "3.11-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp311";
        hash = "sha256-eThX+vN/Nxyv51L+pfyBH0NeQ7j7S1AgWERKf17M+Ck=";
      };
      "3.11-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp311";
        hash = "sha256-L/gpDtx7ksfq5SUX9lSSYz4mey6QZ7rT5MMj0hPnfPU=";
      };

      "3.12-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp312";
        hash = "sha256-RqGqhX9P7uikP8upXA4Kti1AwmzJcwtsaWVZCLo1n40=";
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
        hash = "sha256-jdi//jhTcC9jzZJNoO4lc0pNGc1ckmvgM9dyun0cF10=";
      };
      "3.12-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp312";
        hash = "sha256-1sCaVFMpciRhrwVuc1FG0sjHTCKsdCaoRetp8ya096A=";
      };
    };

  # Note that the prebuilt jaxlib binary requires specific version of CUDA to
  # work. The cuda12 jaxlib binaries only works with CUDA 12.2, and cuda11
  # jaxlib binaries only works with CUDA 11.8. This is why we need to find a
  # binary that matches the provided cudaVersion.
  gpuSrcVersionString = "cuda${cudaVersion}-${pythonVersion}";

  # Find new releases at https://storage.googleapis.com/jax-releases
  # When upgrading, you can get these hashes from prefetch.sh. See
  # https://github.com/google/jax/issues/12879 as to why this specific URL is the correct index.
  gpuSrcs = {
    "cuda12.2-3.9" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp39-cp39-manylinux2014_x86_64.whl";
      hash = "sha256-d8LIl22gIvmWfoyKfXKElZJXicPQIZxdS4HumhwQGCw=";
    };
    "cuda12.2-3.10" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp310-cp310-manylinux2014_x86_64.whl";
      hash = "sha256-PXtWv+UEcMWF8LhWe6Z1UGkf14PG3dkJ0Iop0LiimnQ=";
    };
    "cuda12.2-3.11" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp311-cp311-manylinux2014_x86_64.whl";
      hash = "sha256-QO2WSOzmJ48VaCha596mELiOfPsAGLpGctmdzcCHE/o=";
    };
    "cuda12.2-3.12" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp312-cp312-manylinux2014_x86_64.whl";
      hash = "sha256-ixWMaIChy4Ammsn23/3cCoala0lFibuUxyUr3tjfFKU=";
    };
  };
in
buildPythonPackage {
  pname = "jaxlib";
  inherit version;
  format = "wheel";

  disabled =
    !(
      pythonVersion == "3.9"
      || pythonVersion == "3.10"
      || pythonVersion == "3.11"
      || pythonVersion == "3.12"
    );

  # See https://discourse.nixos.org/t/ofborg-does-not-respect-meta-platforms/27019/6.
  src =
    if !cudaSupport then
      (cpuSrcs."${pythonVersion}-${stdenv.hostPlatform.system}"
        or (throw "jaxlib-bin is not supported on ${stdenv.hostPlatform.system}")
      )
    else
      gpuSrcs."${gpuSrcVersionString}";

  # Prebuilt wheels are dynamically linked against things that nix can't find.
  # Run `autoPatchelfHook` to automagically fix them.
  nativeBuildInputs =
    lib.optionals stdenv.isLinux [ autoPatchelfHook ]
    ++ lib.optionals cudaSupport [ autoAddDriverRunpath ];
  # Dynamic link dependencies
  buildInputs = [ stdenv.cc.cc.lib ];

  # jaxlib contains shared libraries that open other shared libraries via dlopen
  # and these implicit dependencies are not recognized by ldd or
  # autoPatchelfHook. That means we need to sneak them into rpath. This step
  # must be done after autoPatchelfHook and the automatic stripping of
  # artifacts. autoPatchelfHook runs in postFixup and auto-stripping runs in the
  # patchPhase.
  preInstallCheck = lib.optional cudaSupport ''
    shopt -s globstar

    for file in $out/**/*.so; do
      patchelf --add-rpath "${cudaLibPath}" "$file"
    done
  '';

  propagatedBuildInputs = [
    absl-py
    flatbuffers
    ml-dtypes
    scipy
  ];

  # jaxlib looks for ptxas at runtime, eg when running `jax.random.PRNGKey(0)`.
  # Linking into $out is the least bad solution. See
  # * https://github.com/NixOS/nixpkgs/pull/164176#discussion_r828801621
  # * https://github.com/NixOS/nixpkgs/pull/288829#discussion_r1493852211
  # for more info.
  postInstall = lib.optional cudaSupport ''
    mkdir -p $out/${python.sitePackages}/jaxlib/cuda/bin
    ln -s ${lib.getExe' cudaPackages.cuda_nvcc "ptxas"} $out/${python.sitePackages}/jaxlib/cuda/bin/ptxas
  '';

  inherit (jaxlib-build) pythonImportsCheck;

  meta = with lib; {
    description = "XLA library for JAX";
    homepage = "https://github.com/google/jax";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
      "x86_64-darwin"
    ];
    broken =
      !(cudaSupport -> lib.versionAtLeast cudaVersion "11.1")
      || !(cudaSupport -> lib.versionAtLeast cudaPackages.cudnn.version "8.2")
      || !(cudaSupport -> stdenv.isLinux)
      || !(cudaSupport -> (gpuSrcs ? "cuda${cudaVersion}-${pythonVersion}"))
      # Fails at pythonImportsCheckPhase:
      # ...-python-imports-check-hook.sh/nix-support/setup-hook: line 10: 28017 Illegal instruction: 4
      # /nix/store/5qpssbvkzfh73xih07xgmpkj5r565975-python3-3.11.9/bin/python3.11 -c
      # 'import os; import importlib; list(map(lambda mod: importlib.import_module(mod), os.environ["pythonImportsCheck"].split()))'
      || (stdenv.isDarwin && stdenv.isx86_64);
  };
}
