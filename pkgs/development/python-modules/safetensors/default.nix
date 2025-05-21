{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,

  # optional-dependencies
  numpy,
  torch,
  tensorflow,
  flax,
  jax,
  mlx,
  paddlepaddle,
  h5py,
  huggingface-hub,
  setuptools-rust,
  pytest,
  pytest-benchmark,
  hypothesis,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "safetensors";
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "safetensors";
    tag = "v${version}";
    hash = "sha256-dtHHLiTgrg/a/SQ/Z1w0BsuFDClgrMsGiSTCpbJasUs=";
  };

  sourceRoot = "${src.name}/bindings/python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname src sourceRoot;
    hash = "sha256-hjV2cfS/0WFyAnATt+A8X8sQLzQViDzkNI7zN0ltgpU=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  optional-dependencies = lib.fix (self: {
    numpy = [ numpy ];
    torch = self.numpy ++ [
      torch
    ];
    tensorflow = self.numpy ++ [
      tensorflow
    ];
    pinned-tf = self.numpy ++ [
      tensorflow
    ];
    jax = self.numpy ++ [
      flax
      jax
    ];
    mlx = [
      mlx
    ];
    paddlepaddle = self.numpy ++ [
      paddlepaddle
    ];
    testing = self.numpy ++ [
      h5py
      huggingface-hub
      setuptools-rust
      pytest
      pytest-benchmark
      hypothesis
    ];
    all = self.torch ++ self.numpy ++ self.pinned-tf ++ self.jax ++ self.paddlepaddle ++ self.testing;
    dev = self.all;
  });

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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
