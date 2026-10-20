# For the moment we only support the CPU and GPU backends of jaxlib. The TPU
# backend will require some additional work. Those wheels are located here:
# https://storage.googleapis.com/jax-releases/libtpu_releases.html.

# See `python3Packages.jax.passthru` for CUDA tests.

{
  autoPatchelfHook,
  buildPythonPackage,
  fetchPypi,
  lib,
  ml-dtypes,
  numpy,
  python,
  scipy,
  stdenv,
}:

let
  version = "0.12.0";
  inherit (python) pythonVersion;

  # As of 2023-06-06, google/jax upstream is no longer publishing CPU-only wheels to their GCS bucket. Instead the
  # official instructions recommend installing CPU-only versions via PyPI.
  srcs =
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
          python = dist;
          abi = dist;
        };
    in
    {
      "3.12-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp312";
        hash = "sha256-1BlyTNWtDakz7FawhqBN8oUB+9e5mBbvQr4TNXhbUTQ=";
      };
      "3.12-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp312";
        hash = "sha256-antw0NqMXLAvy7vukFeaKBT5kKWzaYieBbnY+ZJHD8Q=";
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
        hash = "sha256-0ACCZ6pUL9yz07tPlao/spve+/8YoGk5Oi4+ZJRueg0=";
      };

      "3.13-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp313";
        hash = "sha256-WV5kLv6Cd6HLDazdCxUjVKMtxUaIsURtqh1LQuS4qPA=";
      };
      "3.13-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp313";
        hash = "sha256-TJEW/4c+I9DqeTudj4GUNetgngm4q1rWMHbcmF99qZw=";
      };
      "3.13-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp313";
        hash = "sha256-JftG2JJ34IAo253LVCsuLoN3yzh/pXRXxY+I+4rLQlI=";
      };

      "3.14-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp314";
        hash = "sha256-L5i6ZmlOjyInetW7eRSII3Dsf5A0+Q2yGtDj258baGM=";
      };
      "3.14-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp314";
        hash = "sha256-bospqoUEY0tGt5kePGsQs7igHstpKJbmjD2IzmF0UUw=";
      };
      "3.14-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp314";
        hash = "sha256-CBXsQpb7kz8FagpGVBPulXcbYXF4eOZ/hLy/8NXhqXU=";
      };
    };
in
buildPythonPackage {
  pname = "jaxlib";
  inherit version;
  format = "wheel";

  __structuredAttrs = true;

  # See https://discourse.nixos.org/t/ofborg-does-not-respect-meta-platforms/27019/6.
  src = (
    srcs."${pythonVersion}-${stdenv.hostPlatform.system}"
      or (throw "jaxlib-bin is not supported on ${stdenv.hostPlatform.system}")
  );

  # Prebuilt wheels are dynamically linked against things that nix can't find.
  # Run `autoPatchelfHook` to automagically fix them.
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  # Dynamic link dependencies
  buildInputs = [ (lib.getLib stdenv.cc.cc) ];

  dependencies = [
    ml-dtypes
    numpy
    scipy
  ];

  pythonImportsCheck = [ "jaxlib" ];

  meta = {
    description = "Prebuilt jaxlib backend from PyPi";
    homepage = "https://github.com/jax-ml/jax";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
    # Keep in sync with `srcs` above
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
