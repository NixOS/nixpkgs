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
  version = "0.8.0";
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
        hash = "sha256-/1Pouvl49rfEB2IVr3jwupacrENO0vclZdh+OMI/AOc=";
      };
      "3.11-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp311";
        hash = "sha256-Qa693vZ6VVpt4XQnpOZs5gpSioFYR+Ldltq85Xn3rPg=";
      };
      "3.11-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp311";
        hash = "sha256-u2AqjCTGFMuMpu7tPnCnM9k5nGoviJAKAlJiPNZydrU=";
      };

      "3.12-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp312";
        hash = "sha256-LIZ1v4bjka/k+NhjCAvhoCTXNN/T3RN/eqjn8iCRrc0=";
      };
      "3.12-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp312";
        hash = "sha256-2D/4zxsHApljnNpPhCdwf2kFHchCHln7tzMFUjk3Vw0=";
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
        hash = "sha256-9gqsD2Tp5wpc7zQf4pJoRRhpVRTHGtAANndLvtX3MS4=";
      };

      "3.13-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp313";
        hash = "sha256-Zsb1dvVKY+0FL1xGm+9NtyP18FC4OewMQpVzARNBvVg=";
      };
      "3.13-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp313";
        hash = "sha256-s+rFA7kP/sxo8R+hIhM+7yxixTbbKOgB5DbX56m2e/g=";
      };
      "3.13-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp313";
        hash = "sha256-X88zpWOfjxZKRzqceKH6Cy4VrD/L7NbZaqD4i/Jeprs=";
      };
    };
in
buildPythonPackage {
  pname = "jaxlib";
  inherit version;
  format = "wheel";

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
