{ stdenv
, lib
, buildPythonPackage
, cargo
, fetchFromGitHub
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, h5py
, numpy
, pythonOlder
, pytestCheckHook
, rustc
, rustPlatform
, setuptools-rust
, torch
, libiconv
}:

buildPythonPackage rec {
  pname = "safetensors";
<<<<<<< HEAD
  version = "0.3.1";
=======
  version = "0.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-RoIBD+zBKVzXE8OpI8GR371YPxceR4P8B9T1/AHc9vA=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/bindings/python";
    hash = "sha256-tC0XawmKWNGCaByHQfJEfmHM3m/qgTuIpcRaEFJC6dM";
  };

  sourceRoot = "${src.name}/bindings/python";
=======
    hash = "sha256-Qpb5lTw1WEME9tWEGfxC8l8dK9mGMH2rz+O+xGCrUxw";
  };

  patches = [
    # remove after next release
    (fetchpatch {
      name = "commit-cargo-lockfile";
      relative = "bindings/python";
      url = "https://github.com/huggingface/safetensors/commit/a7061b4235b59312010b2dd6f9597381428ee9a2.patch";
      hash = "sha256-iH4vQOL2LU93kd0dSS8/JJxKGb+kDstqnExjYSSwi78";
    })
  ];

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src patches;
    sourceRoot = "source/bindings/python";
    hash = "sha256-tC0XawmKWNGCaByHQfJEfmHM3m/qgTuIpcRaEFJC6dM";
  };

  sourceRoot = "source/bindings/python";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    setuptools-rust
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  nativeCheckInputs = [
    h5py numpy pytestCheckHook torch
  ];
  pytestFlagsArray = [ "tests" ];
  # don't require PaddlePaddle (not in Nixpkgs), Flax, or Tensorflow (onerous) to run tests:
  disabledTestPaths = [
    "tests/test_flax_comparison.py"
    "tests/test_paddle_comparison.py"
    "tests/test_tf_comparison.py"
  ];

  pythonImportsCheck = [
    "safetensors"
  ];

  meta = with lib; {
    homepage = "https://github.com/huggingface/safetensors";
    description = "Fast (zero-copy) and safe (unlike pickle) format for storing tensors";
    changelog = "https://github.com/huggingface/safetensors/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
