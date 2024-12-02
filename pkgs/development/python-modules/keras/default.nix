{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  h5py,
  ml-dtypes,
  namex,
  numpy,
  optree,
  packaging,
  rich,
  tensorflow,
  pythonAtLeast,
  distutils,

  # tests
  dm-tree,
  jax,
  jaxlib,
  pandas,
  pydot,
  pytestCheckHook,
  tf-keras,
  torch,
}:

buildPythonPackage rec {
  pname = "keras";
  version = "3.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "keras-team";
    repo = "keras";
    rev = "refs/tags/v${version}";
    hash = "sha256-qidY1OmlOYPKVoxryx1bEukA7IS6rPV4jqlnuf3y39w=";
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
    optree
    packaging
    rich
    tensorflow
  ] ++ lib.optionals (pythonAtLeast "3.12") [ distutils ];

  pythonImportsCheck = [
    "keras"
    "keras._tf_keras"
  ];

  nativeCheckInputs = [
    dm-tree
    jaxlib
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
      # Tries to install the package in the sandbox
      "test_keras_imports"

      # TypeError: this __dict__ descriptor does not support '_DictWrapper' objects
      "test_reloading_default_saved_model"
    ]
    ++ lib.optionals stdenv.isDarwin [
      # AttributeError: module 'numpy' has no attribute 'float128'. Did you mean: 'float16'?
      "test_spectrogram_error"
    ];

  disabledTestPaths = [
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
    "keras/src/export/export_lib_test.py"

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
