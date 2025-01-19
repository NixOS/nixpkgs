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
  version = "0.4.38";
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
        hash = "sha256-Ya7MuaJ8Z/24RQ9jVyQAGc1FEcudYqROR2R1bThIU60=";
      };
      "3.10-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp310";
        hash = "sha256-7hnBY6j98IOdTBi4il+/tOcxunxDdBbT5Ug+Vwu3ZOQ=";
      };
      "3.10-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp310";
        hash = "sha256-MLL1LLUNdHNK8vR3wlM6elg+O7eyyKzes2Hud9lAV3o=";
      };
      "3.10-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp310";
        hash = "sha256-VcGbnT8zpvxZ9kSqWiH7oCY5zN13bLSptVJmJfV4Of8=";
      };

      "3.11-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp311";
        hash = "sha256-J1H/cDfWqZfQvg53zEvjgcWp+buLMU7bdVwTpv2Wn0U=";
      };
      "3.11-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp311";
        hash = "sha256-Q9tYxMQnYnKWNmpWwQMY4fAPUDaQ4X+Uu0NEKT4ZleA=";
      };
      "3.11-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp311";
        hash = "sha256-P7DqrnNpFXr+y+rVCq8p5z/936d6IzXXIb2XlPPFEOQ=";
      };
      "3.11-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp311";
        hash = "sha256-tn/eq9bf7Qi3do873/tSEWAIX4MFZpvRl77vYdCN4Is=";
      };

      "3.12-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp312";
        hash = "sha256-2tbAqWVnwG0IPARp/sQPIBIQsJk2W9aYvjGm0uyI/Vk=";
      };
      "3.12-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp312";
        hash = "sha256-SW9FsOABojQTCc0MdK8LZwU33O15wWjLIwz8x3PwqoY";
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
        hash = "sha256-8zvK/jLJelYuz2iU18QWdMgMCs3t+lQj1Jr1EUcUmHQ=";
      };
      "3.12-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp312";
        hash = "sha256-P+/qmF8EFYFvO7r9PwOkNwUCde+brJpywTFOFkSsV8E=";
      };

      "3.13-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux2014_x86_64";
        dist = "cp313";
        hash = "sha256-LOd7qM2pJZpLypevwcci5CkabEY6Y/jTcsbtyFEX1iU=";
      };
      "3.13-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux2014_aarch64";
        dist = "cp313";
        hash = "sha256-JIzKN3Hr8ksHD0lwE2TOraM+YTlEWwbHgsylrFrZK/Q=";
      };
      "3.13-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp313";
        hash = "sha256-b+MmuK82Y4fdR8zzElg7Kxf+0ScSybdKZIsYoTy9ur8=";
      };
      "3.13-x86_64-darwin" = getSrcFromPypi {
        platform = "macosx_10_14_x86_64";
        dist = "cp313";
        hash = "sha256-QeVa5YGKiC5XiehI9vFmh6wTK8+7Wl+hFKXRi3jQXy0=";
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
