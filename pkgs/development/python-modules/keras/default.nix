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
  tf2onnx,
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
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "keras";
  version = "3.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "keras-team";
    repo = "keras";
    tag = "v${version}";
    hash = "sha256-T1QY1GwE0X5ARtAueB6kF310kTaeOA+8Obdzx0NrOUs=";
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
    tf2onnx
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
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Tries to install the package in the sandbox
    "test_keras_imports"

    # TypeError: this __dict__ descriptor does not support '_DictWrapper' objects
    "test_reloading_default_saved_model"
  ];

  disabledTestPaths = [
    # These tests succeed when run individually, but crash within the full test suite:
    # ImportError: /nix/store/4bw0x7j3wfbh6i8x3plmzknrdwdzwfla-abseil-cpp-20240722.1/lib/libabsl_cord_internal.so.2407.0.0:
    # undefined symbol: _ZN4absl12lts_2024072216strings_internal13StringifySink6AppendESt17basic_string_viewIcSt11char_traitsIcEE
    "keras/src/export/onnx_test.py"

    # Require internet access
    "integration_tests/dataset_tests"
    "keras/src/applications/applications_test.py"

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

    # TypeError: this __dict__ descriptor does not support '_DictWrapper' objects
    "keras/src/backend/tensorflow/saved_model_test.py"
  ];

  meta = {
    description = "Multi-backend implementation of the Keras API, with support for TensorFlow, JAX, and PyTorch";
    homepage = "https://keras.io";
    changelog = "https://github.com/keras-team/keras/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
