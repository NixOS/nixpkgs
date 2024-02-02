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
  version = "0.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "safetensors";
    rev = "refs/tags/v${version}";
    hash = "sha256-hdPUI8k7CCQwt2C/AsjUHRmAL6ob+yCN97KkWtqOQL8=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/bindings/python";
    hash = "sha256-7n9aYlha6IaPsZ2zMfD5EIkrk8ENwMBwj41s6QU7ml0=";
  };

  sourceRoot = "${src.name}/bindings/python";

  nativeBuildInputs = [
    setuptools-rust
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
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
