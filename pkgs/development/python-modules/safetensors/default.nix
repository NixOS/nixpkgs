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
  fsspec,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "safetensors";
  version = "0.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "safetensors";
    tag = "v${version}";
    hash = "sha256-IyKk29jMAbYW+16mrpqQWjnsmNFEvUwkB048AAx/Cvw=";
  };

  sourceRoot = "${src.name}/bindings/python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-+92fCILZwk/TknGXgR9lRN55WnmkgUJfCszFthstzXs=";
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
      fsspec
    ];
    all = self.torch ++ self.numpy ++ self.pinned-tf ++ self.jax ++ self.paddlepaddle ++ self.testing;
    dev = self.all;
  });

  nativeCheckInputs = [
    h5py
    numpy
    pytestCheckHook
    torch
    fsspec
  ];

  enabledTestPaths = [ "tests" ];

  disabledTests = [
    # AttributeError: module 'torch' has no attribute 'float4_e2m1fn_x2'
    "test_odd_dtype_fp4"

    # AssertionError: 'No such file or directory: notafile' != 'No such file or directory: "notafile"'
    "test_file_not_found"

    # AssertionError:
    #    'Erro[41 chars] 5]: index 20 out of bounds for tensor dimension #1 of size 5'
    # != 'Erro[41 chars] 5]:  SliceOutOfRange { dim_index: 1, asked: 20, dim_size: 5 }'
    "test_numpy_slice"
  ];

  # don't require PaddlePaddle (not in Nixpkgs), Flax, or Tensorflow (onerous) to run tests:
  disabledTestPaths = [
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
