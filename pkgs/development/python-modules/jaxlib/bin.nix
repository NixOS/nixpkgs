# For the moment we only support the CPU and GPU backends of jaxlib. The TPU
# backend will require some additional work. Those wheels are located here:
# https://storage.googleapis.com/jax-releases/libtpu_releases.html.

# See `python3Packages.jax.passthru` for CUDA tests.

{ absl-py
, autoPatchelfHook
, buildPythonPackage
, config
, fetchPypi
, fetchurl
, flatbuffers
, jaxlib-build
, lib
, ml-dtypes
, python
, scipy
, stdenv
  # Options:
, cudaSupport ? config.cudaSupport
, cudaPackagesGoogle
}:

let
  inherit (cudaPackagesGoogle) autoAddDriverRunpath cudaVersion;

  version = "0.4.25";

  inherit (python) pythonVersion;

  cudaLibPath = lib.makeLibraryPath (with cudaPackagesGoogle; [
    cuda_cudart.lib # libcudart.so
    cuda_cupti.lib # libcupti.so
    cudnn.lib # libcudnn.so
    libcufft.lib # libcufft.so
    libcusolver.lib # libcusolver.so
    libcusparse.lib # libcusparse.so
  ]);

  # As of 2023-06-06, google/jax upstream is no longer publishing CPU-only wheels to their GCS bucket. Instead the
  # official instructions recommend installing CPU-only versions via PyPI.
  cpuSrcs =
    let
      getSrcFromPypi = { platform, dist, hash }: fetchPypi {
        inherit version platform dist hash;
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
        hash = "sha256-D9ETq0FN6Fb5DwcmTmzNDLldOS81ecDeq0/wlD73X3M=";
      };
      "3.9-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp39";
        hash = "sha256-Mogfk9XeGVoP0Z4JGiqolBj6J/Yw0wx5tGE6Uc/00cY=";
      };
      "3.9-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp39";
        hash = "sha256-ZmC2h0Eoa9S4ScFJ2GqMNuRI9+OeHUg+edq3nqMAvxs=";
      };

      "3.10-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp310";
        hash = "sha256-3Np0x8jrMozeiv7rzyHskkATj6xU+WMaYLZ5ohH34QA=";
      };
      "3.10-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp310";
        hash = "sha256-O1y9Ok9zFjZGnNrwbEQTIIgRykWO4xJkfo8/rKMvZEU=";
      };
      "3.10-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp310";
        hash = "sha256-vhsm6W6A1C9U93ImoBZxfLlp19II0Ny2GZfxncey2OI=";
      };

      "3.11-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp311";
        hash = "sha256-oN0Jy7Ylg5QYcrahmIlOh6G2TY5N1rU5Rtu0HWQrj18=";
      };
      "3.11-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp311";
        hash = "sha256-DffiGTshbhld/HqKoUUn61JhTsO6TFmhma8vFxla4cE=";
      };
      "3.11-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp311";
        hash = "sha256-N9p4DLVFyiEL+gQCtQgUUq2DC7Bv6elw/RatFNL9xqY=";
      };

      "3.12-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp312";
        hash = "sha256-3Ptxp/VZwTc0WEdpyjA3O8S3PQ/hBXkEYjcOSfNdy+Q=";
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
        hash = "sha256-DpdUK72J9DFtL+tZkRnYpDRAyhUbehZe/w/BJ89FEuc=";
      };
      "3.12-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp312";
        hash = "sha256-Ql1vP6V+odFnSuhLWj01iLoJN/PEf9TxZuuExCQIh7g=";
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
      hash = "sha256-R0H84kNed66VzbtRhe4lrtzer3fXjk4WXxRSTW/EQ9k=";
    };
    "cuda12.2-3.10" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp310-cp310-manylinux2014_x86_64.whl";
      hash = "sha256-x4K3kxTXxwRsWDRmOQLnA/Mzirl8hvaY1UujTviVQ9g=";
    };
    "cuda12.2-3.11" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp311-cp311-manylinux2014_x86_64.whl";
      hash = "sha256-Weso/rKLRwn3YNQsUf7yEZ1+94FO3dkmaGATgTS2xVI=";
    };
    "cuda12.2-3.12" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda12/jaxlib-${version}+cuda12.cudnn89-cp312-cp312-manylinux2014_x86_64.whl";
      hash = "sha256-9GalNKmggR2dvOaWpXB3W+nIzOrBSV/S2GeKD3Qllww=";
    };
    "cuda11.8-3.9" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda11/jaxlib-${version}+cuda11.cudnn86-cp39-cp39-manylinux2014_x86_64.whl";
      hash = "sha256-BWujb84WS9kUdZCSsKUCQtUeLh0oBGJrvnXSKUlogac=";
    };
    "cuda11.8-3.10" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda11/jaxlib-${version}+cuda11.cudnn86-cp310-cp310-manylinux2014_x86_64.whl";
      hash = "sha256-CFJEmlLX4iweOi2IKN0QF6C8lB02reZwbabIIofskJI=";
    };
    "cuda11.8-3.11" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda11/jaxlib-${version}+cuda11.cudnn86-cp311-cp311-manylinux2014_x86_64.whl";
      hash = "sha256-9ZJ+bMt5EMx8s0UCPGnwlPV8hcX4cW3ARBChvaam79I=";
    };
    "cuda11.8-3.12" = fetchurl {
      url = "https://storage.googleapis.com/jax-releases/cuda11/jaxlib-${version}+cuda11.cudnn86-cp312-cp312-manylinux2014_x86_64.whl";
      hash = "sha256-tw3GTanY4PE7B7NKBT2K6QT3LZa/wXw0OvMFa4q1rZM=";
    };
  };

in
buildPythonPackage {
  pname = "jaxlib";
  inherit version;
  format = "wheel";

  disabled = !(pythonVersion == "3.9" || pythonVersion == "3.10" || pythonVersion == "3.11" || pythonVersion == "3.12");

  # See https://discourse.nixos.org/t/ofborg-does-not-respect-meta-platforms/27019/6.
  src =
    if !cudaSupport then
      (
        cpuSrcs."${pythonVersion}-${stdenv.hostPlatform.system}"
          or (throw "jaxlib-bin is not supported on ${stdenv.hostPlatform.system}")
      ) else gpuSrcs."${gpuSrcVersionString}";

  # Prebuilt wheels are dynamically linked against things that nix can't find.
  # Run `autoPatchelfHook` to automagically fix them.
  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ]
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
    ln -s ${lib.getExe' cudaPackagesGoogle.cuda_nvcc "ptxas"} $out/${python.sitePackages}/jaxlib/cuda/bin/ptxas
  '';

  inherit (jaxlib-build) pythonImportsCheck;

  meta = with lib; {
    description = "XLA library for JAX";
    homepage = "https://github.com/google/jax";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.asl20;
    maintainers = with maintainers; [ samuela ];
    platforms = [ "aarch64-darwin" "x86_64-linux" "x86_64-darwin" ];
    broken =
      !(cudaSupport -> lib.versionAtLeast cudaVersion "11.1")
      || !(cudaSupport -> lib.versionAtLeast cudaPackagesGoogle.cudnn.version "8.2")
      || !(cudaSupport -> stdenv.isLinux)
      || !(cudaSupport -> (gpuSrcs ? "cuda${cudaVersion}-${pythonVersion}"));
  };
}
