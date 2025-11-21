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
  version = "3.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "keras-team";
    repo = "keras";
    tag = "v${version}";
    hash = "sha256-xuCxeQD8NAn7zlqCG+GyFjL6NlnIkGie+4GxzLGsyUg=";
  };

  # Use a raw string to prevent LaTeX codes from being interpreted as escape sequences.
  # SyntaxError: invalid escape sequence '\h
  # Fix submitted upstream: https://github.com/keras-team/keras/pull/21790
  postPatch = ''
    substituteInPlace keras/src/quantizers/gptq_test.py \
      --replace-fail \
        'CALIBRATION_TEXT = """' \
        'CALIBRATION_TEXT = r"""'
  '';

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
    "test_image_dataset_from_directory_binary_grain"
    "test_image_dataset_from_directory_color_modes_grain"
    "test_image_dataset_from_directory_crop_to_aspect_ratio_grain"
    "test_image_dataset_from_directory_follow_links_grain"
    "test_image_dataset_from_directory_manual_labels_grain"
    "test_image_dataset_from_directory_multiclass_grain"
    "test_image_dataset_from_directory_no_labels_grain"
    "test_image_dataset_from_directory_not_batched_grain"
    "test_image_dataset_from_directory_pad_to_aspect_ratio_grain"
    "test_image_dataset_from_directory_shuffle_grain"
    "test_image_dataset_from_directory_validation_split_grain"
    "test_sample_count_grain"
    "test_text_dataset_from_directory_binary_grain"
    "test_text_dataset_from_directory_follow_links_grain"
    "test_text_dataset_from_directory_manual_labels_grain"
    "test_text_dataset_from_directory_multiclass_grain"
    "test_text_dataset_from_directory_not_batched_grain"
    "test_text_dataset_from_directory_standalone_grain"
    "test_text_dataset_from_directory_validation_split_grain"

    # Tries to install the package in the sandbox
    "test_keras_imports"

    # TypeError: this __dict__ descriptor does not support '_DictWrapper' objects
    "test_reloading_default_saved_model"

    # E       AssertionError:
    # E       - float32
    # E       + float64
    "test_angle_bool"
    "test_angle_int16"
    "test_angle_int32"
    "test_angle_int8"
    "test_angle_uint16"
    "test_angle_uint32"
    "test_angle_uint8"
    "test_bartlett_bfloat16"
    "test_bartlett_bool"
    "test_bartlett_float16"
    "test_bartlett_float32"
    "test_bartlett_float64"
    "test_bartlett_int16"
    "test_bartlett_int32"
    "test_bartlett_int64"
    "test_bartlett_int8"
    "test_bartlett_none"
    "test_bartlett_uint16"
    "test_bartlett_uint32"
    "test_bartlett_uint8"
    "test_blackman_bfloat16"
    "test_blackman_bool"
    "test_blackman_float16"
    "test_blackman_float32"
    "test_blackman_float64"
    "test_blackman_int16"
    "test_blackman_int32"
    "test_blackman_int64"
    "test_blackman_int8"
    "test_blackman_none"
    "test_blackman_uint16"
    "test_blackman_uint32"
    "test_blackman_uint8"
    "test_eye_none"
    "test_hamming_bfloat16"
    "test_hamming_bool"
    "test_hamming_float16"
    "test_hamming_float32"
    "test_hamming_float64"
    "test_hamming_int16"
    "test_hamming_int32"
    "test_hamming_int64"
    "test_hamming_int8"
    "test_hamming_none"
    "test_hamming_uint16"
    "test_hamming_uint32"
    "test_hamming_uint8"
    "test_hanning_bfloat16"
    "test_hanning_bool"
    "test_hanning_float16"
    "test_hanning_float32"
    "test_hanning_float64"
    "test_hanning_int16"
    "test_hanning_int32"
    "test_hanning_int64"
    "test_hanning_int8"
    "test_hanning_none"
    "test_hanning_uint16"
    "test_hanning_uint32"
    "test_hanning_uint8"
    "test_identity_none"
    "test_kaiser_bfloat16"
    "test_kaiser_bool"
    "test_kaiser_float16"
    "test_kaiser_float32"
    "test_kaiser_float64"
    "test_kaiser_int16"
    "test_kaiser_int32"
    "test_kaiser_int64"
    "test_kaiser_int8"
    "test_kaiser_none"
    "test_kaiser_uint16"
    "test_kaiser_uint32"
    "test_kaiser_uint8"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Hangs forever
    "test_fit_with_data_adapter"
  ];

  disabledTestPaths = [
    # Require unpackaged `grain`
    "keras/src/layers/preprocessing/data_layer_test.py"
    "keras/src/layers/preprocessing/image_preprocessing/resizing_test.py"
    "keras/src/layers/preprocessing/rescaling_test.py"
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
