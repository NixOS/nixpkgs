{ stdenv
, lib
, buildPythonPackage
, cargo
, fetchFromGitHub
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
  version = "0.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-RoIBD+zBKVzXE8OpI8GR371YPxceR4P8B9T1/AHc9vA=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "source/bindings/python";
    hash = "sha256-tC0XawmKWNGCaByHQfJEfmHM3m/qgTuIpcRaEFJC6dM";
  };

  sourceRoot = "source/bindings/python";

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
