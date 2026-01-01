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
<<<<<<< HEAD
  version = "0.8.2";
=======
  version = "0.8.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
        hash = "sha256-zPd9qReiCTUkfJkGkd7Py90Gwl7wrJTZFKBKrbIvcUw=";
=======
        hash = "sha256-IvSJ+1yL4Np75eSVehCTazdgoWlmj4slxdCcUcPvR/Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      };
      "3.11-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp311";
<<<<<<< HEAD
        hash = "sha256-u4m+RSsbgI0/iPwBxBWzZKJgvkzHrBIMA4AJ9hUKMtw=";
=======
        hash = "sha256-/zK2Mg1ykTHvryKTmCW1LXWVfITDKvKwsb2zPPJ7p18=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      };
      "3.11-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp311";
<<<<<<< HEAD
        hash = "sha256-SQvwywKcc8ZclDESS4bNyVCC28H7dvxUnSTXXaM+VFQ=";
=======
        hash = "sha256-hlrdVhOYg0BfPxXJsN5qZKuPSqVJ3/GWty28hr5szB8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      };

      "3.12-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp312";
<<<<<<< HEAD
        hash = "sha256-K5eJvQj4sMxaXBKuiW/kMtWULjLkFwkbi1qWqab9XPE=";
=======
        hash = "sha256-r0kkGJ/FO2kjdxW1bry/xxu5HKFhhBQ9zvDUMMgXPeY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      };
      "3.12-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp312";
<<<<<<< HEAD
        hash = "sha256-OxblDFtzDJ3QpJ5V8az6pyKwCxrwUipZFVjcwEZCUvI=";
=======
        hash = "sha256-vtHpSujHwWvKRHbY1/WC8NGhAqTmnDqb0gaaDcQidKk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      };
      "3.12-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp312";
<<<<<<< HEAD
        hash = "sha256-Aj3m8/Vtoq9wN5cJllAFhjMf21C1MOy7VLlmbaYzvQA=";
=======
        hash = "sha256-iL3g9TXu6maJ4M1X1At2YNUgaslcfULglWKhCbljpJ8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      };

      "3.13-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp313";
<<<<<<< HEAD
        hash = "sha256-G/vPbD3iIXhPpM22dloJ1xy0KYsVYms9BAmz382Khmc=";
=======
        hash = "sha256-0kW9aieccspfeW34TN1k18nIq8S42JrfSs9FiY2rlYs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      };
      "3.13-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp313";
<<<<<<< HEAD
        hash = "sha256-fDBPOgFpZbnR9SOaigOZpzkl9WBP6RTFymbs9zS/ZCI=";
=======
        hash = "sha256-vWl8FxrOHi6dbtkQp484WzxAlc7ikLAlWqWISPKs3qs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      };
      "3.13-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp313";
<<<<<<< HEAD
        hash = "sha256-TQBtuWvgIMgWUhKhIWNy+KysT/T4+wZ3Q9aU7yswGs4=";
      };

      "3.14-x86_64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_x86_64";
        dist = "cp314";
        hash = "sha256-5ql9+wIy7tmiu244KOT2gtusGn/qhAv9pXTK4tv1+vk=";
      };
      "3.14-aarch64-linux" = getSrcFromPypi {
        platform = "manylinux_2_27_aarch64";
        dist = "cp314";
        hash = "sha256-aBCN/w3nStxGgBa+mhn4Dv5IxmDA1aEiKHCUtEsJKvw=";
      };
      "3.14-aarch64-darwin" = getSrcFromPypi {
        platform = "macosx_11_0_arm64";
        dist = "cp314";
        hash = "sha256-vv+wBOfutcmvskQ54rLPRaTuPj6K30XjVe3yr2Ks+Lg=";
=======
        hash = "sha256-oDSfboF53Il9M665DsZrSoBBMw+7uo0HHcYWfNInFTk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
