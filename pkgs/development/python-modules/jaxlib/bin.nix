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
  version = "0.6.2";
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
      "3.10-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp310";
        hash = "sha256-wIeg62+39vj1TVb0cwMo395QQN07Xd+oEOfCjqcQK0I=";
      };
      "3.10-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp310";
        hash = "sha256-QgXQmM6O+19/4v5QmLrmA2CU3I2IKfXg4NepsVUyYzY=";
      };
      "3.10-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp310";
        hash = "sha256-2kYBsrXcjCPWr7KT6s+5rsTh0YccsvKcWhUdED5zsPg=";
      };

      "3.11-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp311";
        hash = "sha256-M11+NRXOeLUqQQE29Gqkp+oU0OfWQPNOHhN0CVVK0Kw=";
      };
      "3.11-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp311";
        hash = "sha256-Eern4FvFp5h12jYySvue3dS66u8qA4bK9tTzcgua7yg=";
      };
      "3.11-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp311";
        hash = "sha256-ogj/YcWBKNMGu05a0IWL0rCWDywcEK1CxUj3SmDAAg4=";
      };

      "3.12-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp312";
        hash = "sha256-8d0JtIGpPB1MdQAT9Gf3QZRJO6e9KfzU0c7BbjohT2U=";
      };
      "3.12-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp312";
        hash = "sha256-h+wtycPtmrk27shTUWDF+9LISZSFWfHF2qdfY/q+WUI=";
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
        hash = "sha256-NNimhKi+lJ3YfdSsyXEBtBBqDcmtFR7IkdoHIxmle5k=";
      };

      "3.13-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp313";
        hash = "sha256-+UFj8UyP07qTrhS2Maus8UywMbugtZE4hpmEtNEDdfg=";
      };
      "3.13-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp313";
        hash = "sha256-cEmIN8r1OL1Fj/aFjIv9QE24IBWrqPZjZwGX+pkA/wI=";
      };
      "3.13-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp313";
        hash = "sha256-v/Z7GIEzzh8BEcexY6wyH9ZGtZ7SIepIkGPi4PhcuWc=";
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
