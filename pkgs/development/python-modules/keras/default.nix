{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  distutils,
  h5py,
  ml-dtypes,
  namex,
  numpy,
  onnxruntime,
  optree,
  packaging,
  pythonAtLeast,
  rich,
  scikit-learn,
  tensorflow,

  # tests
  dm-tree,
  jax,
  pandas,
  pydot,
  pytestCheckHook,
  tf-keras,
  torch,
}:

buildPythonPackage rec {
  pname = "keras";
  version = "3.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "keras-team";
    repo = "keras";
    tag = "v${version}";
    hash = "sha256-sbAGiI1Ai0MPiQ8AMpa5qX6hYt/plsIqhn9xYLBb120=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    absl-py
    h5py
    ml-dtypes
    namex
    numpy
    onnxruntime
    optree
    packaging
    rich
    scikit-learn
    tensorflow
  ] ++ lib.optionals (pythonAtLeast "3.12") [ distutils ];

  pythonImportsCheck = [
    "keras"
    "keras._tf_keras"
  ];

  nativeCheckInputs = [
    dm-tree
    jax
    pandas
    pydot
    pytestCheckHook
    tf-keras
    torch
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests =
    [
      # Requires onnx which is currently broken
      "test_export_onnx"

      # Tries to install the package in the sandbox
      "test_keras_imports"

      # TypeError: this __dict__ descriptor does not support '_DictWrapper' objects
      "test_reloading_default_saved_model"

      # ValueError: The truth value of an empty array is ambiguous.
      # Use `array.size > 0` to check that an array is not empty.
      "test_min_max_norm"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # TypeError: Cannot convert a MPS Tensor to float64 dtype as the MPS framework doesn't support float64. Please use float32 instead.
      "test_dynamic_backend_torch"
      # AttributeError: module 'numpy' has no attribute 'float128'. Did you mean: 'float16'?
      "test_spectrogram_error"
    ];

  disabledTestPaths = [
    # Require onnx which is currently broken
    "keras/src/export/onnx_test.py"

    # Datasets are downloaded from the internet
    "integration_tests/dataset_tests"

    # TypeError: test_custom_fit.<locals>.CustomModel.train_step() missing 1 required positional argument: 'data'
    "integration_tests/jax_custom_fit_test.py"

    # RuntimeError: Virtual devices cannot be modified after being initialized
    "integration_tests/tf_distribute_training_test.py"

    # AttributeError: 'CustomModel' object has no attribute 'zero_grad'
    "integration_tests/torch_custom_fit_test.py"

    # Fails for an unclear reason:
    # self.assertLen(list(net.parameters()), 2
    # AssertionError: 0 != 2
    "integration_tests/torch_workflow_test.py"

    # Most tests require internet access
    "keras/src/applications/applications_test.py"

    # TypeError: this __dict__ descriptor does not support '_DictWrapper' objects
    "keras/src/backend/tensorflow/saved_model_test.py"

    # KeyError: 'Unable to synchronously open object (bad object header version number)'
    "keras/src/saving/file_editor_test.py"
  ];

  meta = {
    description = "Multi-backend implementation of the Keras API, with support for TensorFlow, JAX, and PyTorch";
    homepage = "https://keras.io";
    changelog = "https://github.com/keras-team/keras/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
