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
  version = "0.11.1";
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
        hash = "sha256-w9zsO7M+v1x23DP5YseWZSwHftskZGT6Mssdj8tgh+Y=";
      };
      "3.12-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp312";
        hash = "sha256-R7qzp9qKgY+efd7NTtgVQpyqKEDtqelou20zudjFIGc=";
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
        hash = "sha256-OE9jMzHAEkkczWXDjUfNgNQTH1s4UmlHZr/6k4XdyfM=";
      };

      "3.13-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp313";
        hash = "sha256-fr6Gp7iR/NqD5/Y0pnfShWgae4Cz7J7UNVNgeKg3Gs8=";
      };
      "3.13-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp313";
        hash = "sha256-OmeaSbjTKbbkMfOutmZGfG76x1Djsu6Q0OdO/nlZ5kM=";
      };
      "3.13-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp313";
        hash = "sha256-x1GK8xaKtM8KALkvVGMBi68NrT+qOzWKPWiJlq+m/VA=";
      };

      "3.14-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp314";
        hash = "sha256-c56teS3bhUyzyl3s/gCqsIpzETGrLL7tm3T0VFyS/QE=";
      };
      "3.14-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp314";
        hash = "sha256-ImYW3wJ/E0jad3ZHU8bB4vTUW1VRtnvP3K/PnK3y4oA=";
      };
      "3.14-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp314";
        hash = "sha256-oGPWEQ0papNZM8Nap+1hs6Iq4kZuOINO7NSK4tFPuKM=";
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
