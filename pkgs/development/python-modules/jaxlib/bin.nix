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
  version = "0.5.3";
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
        hash = "sha256-Ur5sl3Wv9zimEXDYwEdQXHW7eZpFUY5mp6CQgSexF4U=";
      };
      "3.10-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp310";
        hash = "sha256-lyQA20r26FJw2B215uYg0xOV8EcuUQxQ381Ms/crciA=";
      };
      "3.10-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp310";
        hash = "sha256-SP9cifuKD+BNR16d3AdLSHmpHXq2ilHOxc0eh/gebEc=";
      };

      "3.11-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp311";
        hash = "sha256-KeFTD8gYMyFvHii1eNDFlpdlT3LuMcekTtd1O69axGY=";
      };
      "3.11-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp311";
        hash = "sha256-pGZvgdcsBg7T5YHe0RapyqmwpwoUilTLEqHTr8o2JLU=";
      };
      "3.11-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp311";
        hash = "sha256-tivYsp5aT5v6pXyNr24EggssmU9Ejz3sYC1kJVVF6fI=";
      };

      "3.12-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp312";
        hash = "sha256-Wl6IqxzW/feNaavjVE6PCcziAN0zm7hfvjwupn8qXmg=";
      };
      "3.12-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp312";
        hash = "sha256-vd9jYDd6oceS5H/YfzB8NC4zHl/zWC+UCxvKAPa0vHM=";
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
        hash = "sha256-05Tb3koca9Z1Ac+ynTgZoQuQDLU0zA/GAzGfcJLyTPo=";
      };

      "3.13-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp313";
        hash = "sha256-u3WTy3//yxOWPyL6UintlguPtK5ew7CCAEjL1n8ejjE=";
      };
      "3.13-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp313";
        hash = "sha256-6QS5Le37x+VFclqNdnaYcDCunAaQAdlHAbwQnG2rQQA=";
      };
      "3.13-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp313";
        hash = "sha256-MTIcJSgqBqbfyUBQe8FNCgrIONjO1sB6oAp/rjTOez8=";
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
