# For the moment we only support the CPU and GPU backends of jaxlib. The TPU
# backend will require some additional work. Those wheels are located here:
# https://storage.googleapis.com/jax-releases/libtpu_releases.html.

# See `python3Packages.jax.passthru` for CUDA tests.

{
  absl-py,
  autoPatchelfHook,
  buildPythonPackage,
  fetchPypi,
  flatbuffers,
  lib,
  ml-dtypes,
  python,
  scipy,
  stdenv,
}:

let
  version = "0.10.0";
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
          # See the `disabled` attr comment below.
          python = dist;
          abi = dist;
        };
    in
    {
      "3.11-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp311";
        hash = "sha256-m+IpmTpB5bK4TyNOzBml3gLzXt2xGVzwJ71TnhYB4V0=";
      };
      "3.11-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp311";
        hash = "sha256-PblOvIWTddlV3jUEGCrdfOFzPOPTDBXg7wMWAstRpVk=";
      };
      "3.11-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp311";
        hash = "sha256-J3Ay6fB0w/1f/R4MsD1P5m4nLeRyZnzbxBitmbIbZGo=";
      };

      "3.12-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp312";
        hash = "sha256-sL+4ZaB98ubXQYwLDCkt0pS1UAUjsd1YcrGA2yqkgNQ=";
      };
      "3.12-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp312";
        hash = "sha256-qh1w8aTifrQDZU5x4vso1XhtPpt3/BhH6MU4mICSfKQ=";
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
        hash = "sha256-fB2bRjMnx6IzPyEBFOywTyj+/FG6gjOoWiKAzOdb20I=";
      };

      "3.13-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp313";
        hash = "sha256-0wPcMbZei3k9VgD4GxWDvgPcm4dqTBCz4lm2YJocvjs=";
      };
      "3.13-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp313";
        hash = "sha256-bY14twcLNOTFu6X34Qkn5/Sqybab4X6bCliYVTpDOPM=";
      };
      "3.13-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp313";
        hash = "sha256-OEY1//VYmaKVu8gu5sb3c6MA54fcRyypK755q/qsg2k=";
      };

      "3.14-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp314";
        hash = "sha256-KkLPBMD4i8A7FQoX+n3bsvQOCWZn7IobhA7YeRPm5zU=";
      };
      "3.14-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp314";
        hash = "sha256-rUfgckMJeewhY3qkh9TcRkAouOm+JyaPN95pU2x240E=";
      };
      "3.14-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp314";
        hash = "sha256-mLJmcpQ2cnQoc/ZbwDIWgZ/FUyXJnxRlkNAHwBcr/zA=";
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
    absl-py
    flatbuffers
    ml-dtypes
    scipy
  ];

  pythonImportsCheck = [ "jaxlib" ];

  meta = {
    description = "Prebuilt jaxlib backend from PyPi";
    homepage = "https://github.com/google/jax";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
    badPlatforms = [
      # Fails at pythonImportsCheckPhase:
      # ...-python-imports-check-hook.sh/nix-support/setup-hook: line 10: 28017 Illegal instruction: 4
      # /nix/store/5qpssbvkzfh73xih07xgmpkj5r565975-python3-3.11.9/bin/python3.11 -c
      # 'import os; import importlib; list(map(lambda mod: importlib.import_module(mod), os.environ["pythonImportsCheck"].split()))'
      "x86_64-darwin"
    ];
  };
}
