{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # nativeBuildInputs
  cargo,
  rustc,
  setuptools-rust,

  # buildInputs
  libiconv,

  # tests
  h5py,
  numpy,
  pytestCheckHook,
  torch,
}:

buildPythonPackage rec {
  pname = "safetensors";
  version = "0.4.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "safetensors";
    rev = "refs/tags/v${version}";
    hash = "sha256-gr4hBbecaGHaoNhRQQXWfLfNB0/wQPKftSiTnGgngog=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sourceRoot = "${src.name}/bindings/python";
    hash = "sha256-zDXzEVvmJF1dEVUFGBc3losr9U1q/qJCjNFkdJ/pCd4=";
  };

  sourceRoot = "${src.name}/bindings/python";

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    setuptools-rust
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  nativeCheckInputs = [
    h5py
    numpy
    pytestCheckHook
    torch
  ];
  pytestFlagsArray = [ "tests" ];
  # don't require PaddlePaddle (not in Nixpkgs), Flax, or Tensorflow (onerous) to run tests:
  disabledTestPaths =
    [
      "tests/test_flax_comparison.py"
      "tests/test_paddle_comparison.py"
      "tests/test_tf_comparison.py"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # don't require mlx (not in Nixpkgs) to run tests
      "tests/test_mlx_comparison.py"
    ];

  pythonImportsCheck = [ "safetensors" ];

  meta = {
    homepage = "https://github.com/huggingface/safetensors";
    description = "Fast (zero-copy) and safe (unlike pickle) format for storing tensors";
    changelog = "https://github.com/huggingface/safetensors/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
