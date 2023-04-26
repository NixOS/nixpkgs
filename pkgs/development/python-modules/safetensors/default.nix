{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, h5py
, numpy
, pythonOlder
, pytestCheckHook
, rustPlatform
, setuptools-rust
, torch
, libiconv
}:

buildPythonPackage rec {
  pname = "safetensors";
  version = "0.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/v${version}";
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

  nativeBuildInputs = with rustPlatform; [
    setuptools-rust
    rust.cargo
    rust.rustc
    cargoSetupHook
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
