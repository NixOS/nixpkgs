{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

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
  version = "3.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "keras-team";
    repo = "keras";
    tag = "v${version}";
    hash = "sha256-J/NPLR9ShKhvHDU0/NpUNp95RViS2KygqvnuDHdwiP0=";
  };

  # The two following patches mitigate CVE breaches.
  # The patches are part of the keras 3.12.0 release.
  # We choose to backport the relevant commits instead of updating keras to 3.12.0 as this latest
  # release includes breaking changes.
  patches = [
    # Fixes CVE-2025-12058
    # https://github.com/advisories/GHSA-mq84-hjqx-cwf2
    (fetchpatch2 {
      name = "patch-CVE-2025-12058";
      url = "https://github.com/keras-team/keras/commit/61ac8c1e51862c471dee7b49029c356f55531487.patch";
      hash = "sha256-tvWYde3AERV1w3gvQ70NNLo0xNxgyZFzf5LF48Axymg=";
    })
    # Fixes CVE-2025-12060
    # https://github.com/advisories/GHSA-28jp-44vh-q42h
    (fetchpatch2 {
      name = "patch-CVE-2025-12060";
      url = "https://github.com/keras-team/keras/commit/47fcb397ee4caffd5a75efd1fa3067559594e951.patch";
      hash = "sha256-tiBRXGp+PHiY0VXCdcpmpq4PHORvREVpr/QfQcwqJdk=";
    })
  ];

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
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [ distutils ];

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
    # Require unpackaged `grain`
    "test_fit_with_data_adapter_grain_dataloader"
    "test_fit_with_data_adapter_grain_datast"
    "test_fit_with_data_adapter_grain_datast_with_len"

    # Tries to install the package in the sandbox
    "test_keras_imports"

    # TypeError: this __dict__ descriptor does not support '_DictWrapper' objects
    "test_reloading_default_saved_model"
  ];

  disabledTestPaths = [
    # Require unpackaged `grain`
    "keras/src/trainers/data_adapters/grain_dataset_adapter_test.py"

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
