{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  dm-tree,
  h5py,
  markdown-it-py,
  ml-dtypes,
  namex,
  numpy,
  optree,
  packaging,
  rich,
  tensorflow,
  jax,
  jaxlib,
  pandas,
  pytest-xdist,
  pytestCheckHook,
  scipy,
  torch,
  tf-keras,
}:

let
  keras = buildPythonPackage rec {
    pname = "keras";
    version = "3.4.1";
    pyproject = true;

    disabled = pythonOlder "3.9";

    src = fetchFromGitHub {
      owner = "keras-team";
      repo = "keras";
      rev = "refs/tags/v${version}";
      hash = "sha256-Pp84wTvcrWnxuksYUrzs9amapwBC8yU1PA0PE5dRl6k=";
    };

    build-system = [ setuptools ];

    dependencies = [
      absl-py
      dm-tree
      h5py
      markdown-it-py
      ml-dtypes
      namex
      numpy
      optree
      rich
      tensorflow
    ];

    pythonImportsCheck = [
      "keras"
      "keras._tf_keras"
    ];

    nativeCheckInputs = [
      jax
      jaxlib
      pandas
      pytest-xdist
      pytestCheckHook
      scipy
      numpy
      torch
      tf-keras
    ];

    disabledTests = [
      # Try to write to and then read from the build directory:
      # FileNotFoundError: [Errno 2] No such file or directory: '/build/source/temp_dir/...
      "test_invalid_path_warning"
      "test_member_within_base_dir"
      "test_symlink_within_base_dir"
      "test_symlink_within_base_dir"

      # tensorflow.python.framework.errors_impl.UnimplementedError: Graph execution error:
      "test_swap_ema_weights"
      "test_swap_ema_weights_on_epoch"
      "test_swap_ema_weights_with_invalid_optimizer"

      # tensorflow/core/framework/op_kernel.cc:1828] OP_REQUIRES failed at xla_ops.cc:503 : UNIMPLEMENTED: Could not find compiler for platform Host: NOT_FOUND: could not find registered compiler for platform Host -- was support for that platform linked in?
      # Maybe, those tests will start working once tensorflow will have been updated to 2.15.0
      "test_conv1d1"
      "test_conv1d2"
      "test_conv1d3"
      "test_conv1d4"
      "test_conv1d_basic1"
      "test_conv1d_basic2"
      "test_conv1d_basic3"
      "test_conv2d2"
      "test_conv2d3"
      "test_conv2d4"
      "test_conv2d5"
      "test_conv2d_basic1"
      "test_conv2d_basic2"
      "test_conv_2d_group_20"
      "test_conv_2d_group_21"
      "test_conv_2d_group_22"
      "test_conv3d1"
      "test_conv3d2"
      "test_conv3d3"
      "test_conv3d4"
      "test_conv3d_basic1"
      "test_conv3d_basic2"
      "test_enable_lora_conv1d_kernel_size2_strides2"
      "test_enable_lora_conv2d_kernel_size2_strides2"
      "test_enable_lora_conv3d_kernel_size2_strides2"
      "test_evaluate_flow_jit"
      "test_fit_flow_jit"
      "test_fit_flow_steps_per_epoch_jit"
      "test_fit_with_val_split_jit"
      "test_fit_with_val_split_steps_per_epoch_jit"
      "test_global_seed_generator"
      "test_on_batch_methods_jit"
      "test_on_batch_methods_without_training_jit"
      "test_predict_flow_jit"
      "test_predict_flow_struct_jit"
      "test_slice_update"
      "test_split_with_jit_in_tf"
      "test_steps_per_execution_steps_count"

      # AttributeError: 'DType' object has no attribute 'is_numeric'
      "test_compute_float8_scale"
      "test_densifying_unary_indexed_slices_correctness_isfinite"
      "test_densifying_unary_sparse_correctness_isfinite"
      "test_downscaling_stateful"
      "test_finite_step_stateful"
      "test_infinite_step_stateful"
      "test_isfinite"
      "test_isfinite_bfloat16"
      "test_isfinite_bool"
      "test_isfinite_float16"
      "test_isfinite_float32"
      "test_isfinite_float64"
      "test_isfinite_none"
      "test_isinf_bfloat16"
      "test_isinf_bool"
      "test_isinf_float16"
      "test_isinf_float32"
      "test_isinf_float64"
      "test_isinf_none"
      "test_isnan"
      "test_isnan_bfloat16"
      "test_isnan_bool"
      "test_isnan_float16"
      "test_isnan_float32"
      "test_isnan_float64"
      "test_isnan_none"
      "test_loss_scaling_prevents_underflow"
      "test_nan_to_num"
      "test_nan_to_num_bfloat16"
      "test_nan_to_num_bool"
      "test_nan_to_num_float16"
      "test_nan_to_num_float32"
      "test_nan_to_num_float64"
      "test_nan_to_num_none"
      "test_quantize_float8"
      "test_quantize_float8"
      "test_quantize_float8"
      "test_quantize_float8_dtype_argument"
      "test_quantize_float8_dtype_argument"
      "test_quantize_float8_fitting"
      "test_quantize_float8_fitting"
      "test_r2_sklearn_comparison0"
      "test_r2_sklearn_comparison1"
      "test_r2_sklearn_comparison2"
      "test_r2_tfa_comparison0"
      "test_r2_tfa_comparison1"
      "test_r2_tfa_comparison2"
      "test_r2_tfa_comparison3"
      "test_r2_tfa_comparison4"
      "test_r2_tfa_comparison5"
      "test_r2_tfa_comparison6"
      "test_r2_tfa_comparison7"
      "test_r2_tfa_comparison8"
      "test_sparse_correctness_loss_scale_optimizer_sgd"
      "test_sparse_gradients_loss_scale_optimizer_sgd"
      "test_swap_ema_weights_with_loss_scale_optimizer"
      "test_upscaling_stateful"

      # Require internet access
      "test_application_base_ConvNeXtBase_channels_last"
      "test_application_base_ConvNeXtLarge_channels_last"
      "test_application_base_ConvNeXtSmall_channels_last"
      "test_application_base_ConvNeXtTiny_channels_last"
      "test_application_base_ConvNeXtXLarge_channels_last"
      "test_application_base_DenseNet121_channels_last"
      "test_application_base_DenseNet169_channels_last"
      "test_application_base_DenseNet201_channels_last"
      "test_application_base_EfficientNetB0_channels_last"
      "test_application_base_EfficientNetB1_channels_last"
      "test_application_base_EfficientNetB2_channels_last"
      "test_application_base_EfficientNetB3_channels_last"
      "test_application_base_EfficientNetB4_channels_last"
      "test_application_base_EfficientNetB5_channels_last"
      "test_application_base_EfficientNetB6_channels_last"
      "test_application_base_EfficientNetB7_channels_last"
      "test_application_base_EfficientNetV2B0_channels_last"
      "test_application_base_EfficientNetV2B1_channels_last"
      "test_application_base_EfficientNetV2B2_channels_last"
      "test_application_base_EfficientNetV2B3_channels_last"
      "test_application_base_EfficientNetV2L_channels_last"
      "test_application_base_EfficientNetV2M_channels_last"
      "test_application_base_EfficientNetV2S_channels_last"
      "test_application_base_MobileNet_channels_last"
      "test_application_base_MobileNetV2_channels_last"
      "test_application_base_MobileNetV3Large_channels_last"
      "test_application_base_MobileNetV3Small_channels_last"
      "test_application_base_NASNetLarge_channels_last"
      "test_application_base_NASNetMobile_channels_last"
      "test_application_base_InceptionResNetV2_channels_last"
      "test_application_base_InceptionV3_channels_last"
      "test_application_base_ResNet101_channels_last"
      "test_application_base_ResNet101V2_channels_last"
      "test_application_base_ResNet152_channels_last"
      "test_application_base_ResNet152V2_channels_last"
      "test_application_base_ResNet50_channels_last"
      "test_application_base_ResNet50V2_channels_last"
      "test_application_base_VGG16_channels_last"
      "test_application_base_VGG19_channels_last"
      "test_application_base_Xception_channels_last"
    ];

    disabledTestPaths = [
      # Require internet access
      "integration_tests/dataset_tests/boston_housing_test.py"
      "integration_tests/dataset_tests/california_housing_test.py"
      "integration_tests/dataset_tests/cifar100_test.py"
      "integration_tests/dataset_tests/cifar10_test.py"
      "integration_tests/dataset_tests/fashion_mnist_test.py"
      "integration_tests/dataset_tests/imdb_test.py"
      "integration_tests/dataset_tests/mnist_test.py"
      "integration_tests/dataset_tests/reuters_test.py"
    ];

    # Multiple package conflicts
    # pythonCatchConflictsPhase complains about several conflicts (grpcio, protobuf, tensorboard and tensorboard_plugin_profile)
    doCheck = false;
    passthru.tests = {
      checks = keras.overridePythonAttrs {
        doCheck = true;
        catchConflicts = false;
      };
    };

    meta = {
      description = "Multi-backend implementation of the Keras API, with support for TensorFlow, JAX, and PyTorch";
      homepage = "https://keras.io";
      changelog = "https://github.com/keras-team/keras/releases/tag/v${version}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ NikolaMandic ];
    };
  };
in
keras
