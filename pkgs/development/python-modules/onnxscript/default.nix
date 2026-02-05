{
  lib,
  stdenv,
  config,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  setuptools,

  # dependencies
  ml-dtypes,
  numpy,
  onnx,
  onnx-ir,
  packaging,
  typing-extensions,
  pynvml,

  # tests
  onnxruntime,
  parameterized,
  pytestCheckHook,
  torch,
  torchvision,
  tqdm,

  cudaSupport ? config.cudaSupport,
  onnxscript,
}:

let
  # The following tests are disabled in both
  # - the main derivation (running without GPU access)
  # - passthru.gpuCheck (running with GPU passthrough)
  disabledTests = [
    # fixture 'model_info' not found
    "test_model"

    # RuntimeError: ONNX Runtime failed to evaluate
    # onnxruntime.capi.onnxruntime_pybind11_state.NotImplemented: [ONNXRuntimeError] : 9 :
    # NOT_IMPLEMENTED : Could not find an implementation for SplitToSequence(11) node with name '_inlfunc_aten_split_n0'
    "test_output_match_opinfo__split_cpu_bool"
    "test_output_match_opinfo__split_list_args_cpu_bool"

    # RuntimeError: ONNX Runtime failed to evaluate
    # onnxruntime.capi.onnxruntime_pybind11_state.NotImplemented: [ONNXRuntimeError] : 9 :
    # NOT_IMPLEMENTED : Could not find an implementation for SplitToSequence(11) node with name '_inlfunc_aten_split_with_sizes_n0'
    "test_output_match_opinfo__split_with_sizes_cpu_bool"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # TypeError: Expecting a type not f<class 'typing.Union'> for typeinfo.
    "test_function_has_op_schema_073_div_mode"
    "test_function_has_op_schema_076_einsum"
    "test_function_has_op_schema_116_linalg_vector_norm"
    "test_function_has_op_schema_172_nn_functional_pad"
    "test_function_has_op_schema_208_repeat_interleave"
    "test_function_has_op_schema_209_repeat_interleave"
    "test_function_has_op_schema_268_argmax"
    "test_function_has_op_schema_269_argmin"
    "test_function_has_op_schema_288_logit"
    "test_function_has_op_schema_302_nn_functional_avg_pool2d"
    "test_function_has_op_schema_303_nn_functional_avg_pool3d"
    "test_function_has_op_schema_318_nn_functional_scaled_dot_product_attention"
    "test_function_has_op_schema_319_ops_aten__scaled_dot_product_flash_attention"
    "test_function_has_op_schema_320_ops_aten__scaled_dot_product_efficient_attention"
    "test_function_has_op_schema_321_ops_aten_upsample_bilinear2d_default"
    "test_function_has_op_schema_322_ops_aten__upsample_bilinear2d_aa"
    "test_function_has_op_schema_323_ops_aten_upsample_bilinear2d_vec"
    "test_function_has_op_schema_324_ops_aten_upsample_bicubic2d_default"
    "test_function_has_op_schema_325_ops_aten__upsample_bicubic2d_aa"
    "test_function_has_op_schema_326_ops_aten_upsample_bicubic2d_vec"
    "test_function_has_op_schema_327_ops_aten_upsample_linear1d"
    "test_function_has_op_schema_328_ops_aten_upsample_nearest1d"
    "test_function_has_op_schema_329_ops_aten_upsample_nearest1d_vec"
    "test_function_has_op_schema_330_ops_aten_upsample_nearest2d"
    "test_function_has_op_schema_331_ops_aten_upsample_nearest2d_vec"
    "test_function_has_op_schema_332_ops_aten_upsample_nearest3d"
    "test_function_has_op_schema_333_ops_aten_upsample_nearest3d_vec"
    "test_function_has_op_schema_334_ops_aten_upsample_trilinear3d_default"
    "test_function_has_op_schema_335_ops_aten_upsample_trilinear3d_vec"
    "test_function_has_op_schema_345_ops_aten_stft"
    "test_function_has_op_schema_356_ops_prims_var_default"
    "test_output_match_opinfo__argmax_cpu_float16"
    "test_output_match_opinfo__argmax_cpu_float32"
    "test_output_match_opinfo__argmax_cpu_int32"
    "test_output_match_opinfo__argmax_cpu_int64"
    "test_output_match_opinfo__argmin_cpu_float16"
    "test_output_match_opinfo__argmin_cpu_float32"
    "test_output_match_opinfo__argmin_cpu_int32"
    "test_output_match_opinfo__argmin_cpu_int64"
    "test_output_match_opinfo__div_mode_floor_rounding_cpu_float16"
    "test_output_match_opinfo__div_mode_floor_rounding_cpu_float32"
    "test_output_match_opinfo__div_mode_floor_rounding_cpu_int32"
    "test_output_match_opinfo__div_mode_floor_rounding_cpu_int64"
    "test_output_match_opinfo__div_mode_trunc_rounding_cpu_float32"
    "test_output_match_opinfo__div_mode_trunc_rounding_cpu_int32"
    "test_output_match_opinfo__div_mode_trunc_rounding_cpu_int64"
    "test_output_match_opinfo__einsum_cpu_float16"
    "test_output_match_opinfo__einsum_cpu_float32"
    "test_output_match_opinfo__einsum_cpu_int64"
    "test_output_match_opinfo__linalg_vector_norm_cpu_float16"
    "test_output_match_opinfo__linalg_vector_norm_cpu_float32"
    "test_output_match_opinfo__logit_cpu_bool"
    "test_output_match_opinfo__logit_cpu_float16"
    "test_output_match_opinfo__logit_cpu_float32"
    "test_output_match_opinfo__logit_cpu_int32"
    "test_output_match_opinfo__logit_cpu_int64"
    "test_output_match_opinfo__nn_functional_avg_pool2d_cpu_float16"
    "test_output_match_opinfo__nn_functional_avg_pool2d_cpu_float32"
    "test_output_match_opinfo__nn_functional_avg_pool2d_cpu_int64"
    "test_output_match_opinfo__nn_functional_avg_pool3d_cpu_float32"
    "test_output_match_opinfo__nn_functional_avg_pool3d_cpu_int64"
    "test_output_match_opinfo__nn_functional_pad_constant_cpu_bool"
    "test_output_match_opinfo__nn_functional_pad_constant_cpu_float16"
    "test_output_match_opinfo__nn_functional_pad_constant_cpu_float32"
    "test_output_match_opinfo__nn_functional_pad_constant_cpu_int32"
    "test_output_match_opinfo__nn_functional_pad_constant_cpu_int64"
    "test_output_match_opinfo__nn_functional_pad_reflect_cpu_float16"
    "test_output_match_opinfo__nn_functional_pad_reflect_cpu_float32"
    "test_output_match_opinfo__nn_functional_pad_reflect_cpu_int32"
    "test_output_match_opinfo__nn_functional_pad_reflect_cpu_int64"
    "test_output_match_opinfo__nn_functional_pad_replicate_cpu_float16"
    "test_output_match_opinfo__nn_functional_pad_replicate_cpu_float32"
    "test_output_match_opinfo__nn_functional_pad_replicate_cpu_int32"
    "test_output_match_opinfo__nn_functional_pad_replicate_cpu_int64"
    "test_output_match_opinfo__nn_functional_scaled_dot_product_attention_cpu_float32"
    "test_output_match_opinfo__ops_aten__upsample_bicubic2d_aa_cpu_float32"
    "test_output_match_opinfo__ops_aten__upsample_bilinear2d_aa_cpu_float32"
    "test_output_match_opinfo__ops_aten_stft_cpu_float32"
    "test_output_match_opinfo__ops_aten_upsample_bicubic2d_default_cpu_float32"
    "test_output_match_opinfo__ops_aten_upsample_bicubic2d_vec_cpu_float32"
    "test_output_match_opinfo__ops_aten_upsample_bilinear2d_default_cpu_float32"
    "test_output_match_opinfo__ops_aten_upsample_bilinear2d_vec_cpu_float32"
    "test_output_match_opinfo__ops_aten_upsample_linear1d_cpu_float32"
    "test_output_match_opinfo__ops_aten_upsample_nearest1d_cpu_float32"
    "test_output_match_opinfo__ops_aten_upsample_nearest1d_vec_cpu_float32"
    "test_output_match_opinfo__ops_aten_upsample_nearest2d_cpu_float32"
    "test_output_match_opinfo__ops_aten_upsample_nearest2d_vec_cpu_float32"
    "test_output_match_opinfo__ops_aten_upsample_nearest3d_cpu_float32"
    "test_output_match_opinfo__ops_aten_upsample_nearest3d_vec_cpu_float32"
    "test_output_match_opinfo__ops_aten_upsample_trilinear3d_default_cpu_float32"
    "test_output_match_opinfo__ops_aten_upsample_trilinear3d_vec_cpu_float32"
    "test_output_match_opinfo__ops_prims_var_default_cpu_float16"
    "test_output_match_opinfo__ops_prims_var_default_cpu_float32"
    "test_output_match_opinfo__repeat_interleave_cpu_float16"
    "test_output_match_opinfo__repeat_interleave_cpu_float32"
    "test_output_match_opinfo__repeat_interleave_cpu_int32"
    "test_output_match_opinfo__repeat_interleave_cpu_int64"
  ];

  # The following tests require access to a physical GPU to work, otherwise the interpreter crashes:
  # Fatal Python error: Aborted
  # File "/nix/store/..onnxruntime/capi/onnxruntime_inference_collection.py", line 561 in _create_inference_session
  testsRequiringGpu = [
    "test_affine_conv_fusion_without_pad"
    "test_conv_affine_fusion"
    "test_flatten_to_reshape_dynamic_input"
    "test_flatten_to_reshape_rule"
    "test_fuse_batchnorm_conv"
    "test_fuse_batchnorm_gemm"
    "test_fuse_pad_into_conv"
    "test_hardsigmoid_fusion"
    "test_hardswish_fusion"
    "test_layer_norm_fusion_with_bias"
    "test_layer_norm_fusion_without_bias"
    "test_matmul_add_to_gemm"
    "test_normalize_pad_format"
    "test_reshape_dynamic_reshape_rule"
    "test_reshape_reshape_dynamic_rule"
    "test_reshape_reshape_rule"
    "test_slice_is_redundant_when_ends_is_greater_than_input_shape"
    "test_slice_is_redundant_when_ends_reaches_int64_max"
    "test_successful_full_chain_fusion"
    "test_successful_fuse_successive_clips"
    "test_successful_fuse_successive_min_or_max"
    "test_successful_fuse_successive_relu_clip"
    "test_successful_fuse_successive_relus"
    "test_successful_max_min_to_clip"
    "test_successful_min_max_to_clip"
    "test_successful_remove_optional_bias_conv"
    "test_successful_remove_optional_bias_gemm"
    "test_successful_remove_optional_bias_qlinear_conv"
    "test_transpose_a_matmul_add_to_gemm"
    "test_transpose_ab_matmul_add_to_gemm"
    "test_transpose_b_matmul_add_to_gemm"
  ];
in
buildPythonPackage (finalAttrs: {
  pname = "onnxscript";
  version = "0.5.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxscript";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8QnVfdI5sfPXF72fbbowbGxVRAnNQr55YEi/QEmXbCw=";
  };

  # Fails with python>=3.14
  # TypeError: descriptor '__getitem__' requires a 'typing.Union' object but received a 'tuple'
  postPatch = ''
    substituteInPlace onnxscript/type_annotation.py \
      --replace-fail \
        "return pytype_to_type_strings(Union.__getitem__(constraints))" \
        "return pytype_to_type_strings(Union[constraints])"
  '';

  env = {
    ONNX_SCRIPT_RELEASE = "1";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    ml-dtypes
    numpy
    onnx
    onnx-ir
    packaging
    typing-extensions
  ]
  ++ lib.optionals cudaSupport [
    pynvml
  ];

  pythonImportsCheck = [ "onnxscript" ];

  nativeCheckInputs = [
    onnxruntime
    parameterized
    pytestCheckHook
    torch
    torchvision
    tqdm
  ];

  disabledTests = disabledTests ++ lib.optionals cudaSupport testsRequiringGpu;

  disabledTestPaths = [
    # google.protobuf.message.DecodeError: Error parsing message with type 'onnx.ModelProto'
    "tests/ir/graph_view_test.py"
    "tests/ir/serde_roundtrip_test.py"
    "tests/optimizer/test_models.py"
  ];

  # Importing onnxruntime in the sandbox crashes on aarch64-linux:
  # Fatal Python error: Aborted
  # See https://github.com/NixOS/nixpkgs/pull/481039
  doCheck = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);

  passthru.gpuCheck = onnxscript.overridePythonAttrs {
    requiredSystemFeatures = [ "cuda" ];

    # Skip all tests that are failing independantly of the GPU availability
    disabledTests =
      disabledTests
      ++ [
        # AssertionError: Tensor-likes are not close!
        "test_output_match_opinfo__cumsum_cuda_float16"
        "test_output_match_opinfo__nn_functional_conv1d_cuda_float32"
        "test_output_match_opinfo__nn_functional_embedding_cuda_float16"
        "test_output_match_opinfo__nn_functional_embedding_cuda_float32"
        "test_output_match_opinfo__ops_aten_conv3d_cuda_float32"
        "test_output_match_opinfo__ops_aten_convolution_cuda_float32"
        "test_output_match_opinfo__ops_aten_embedding_bag_cuda_float32"
        "test_output_match_opinfo__ops_aten_embedding_renorm_cuda_float16"
        "test_output_match_opinfo__ops_aten_embedding_renorm_cuda_float32"

        # AssertionError: Scalars are not equal!
        "test_output_match_opinfo__equal_cuda_bool"
        "test_output_match_opinfo__ops_aten_embedding_bag_padding_idx_cuda_float16"
        "test_output_match_opinfo__ops_aten_embedding_bag_padding_idx_cuda_float32"

        # AssertionError: Not equal to tolerance rtol=0, atol=0
        "test_fuse_pad_into_conv_4"
        "test_fuse_pad_into_conv_5"
        "test_fuse_pad_into_conv_6"
        "test_fuse_pad_into_conv_7"

        # TypeError: can't convert cuda:0 device type tensor to numpy. Use Tensor.cpu() to copy the tensor to host memory first.
        "test_output_match_opinfo__index_put_cuda_float16"
        "test_output_match_opinfo__index_put_cuda_float32"
        "test_output_match_opinfo__index_put_cuda_int32"
        "test_output_match_opinfo__index_put_cuda_int64"

        # RuntimeError: ONNX Runtime failed to evaluate
        # onnxruntime.capi.onnxruntime_pybind11_state.InvalidArgument: [ONNXRuntimeError] : 2 :
        # INVALID_ARGUMENT : Non-zero status code returned while running LayerNormalization node.
        # Name:'node_LayerNormalization_0' Status Message: Size of X.shape[axis:] must be larger than 1, got 1
        "test_output_match_opinfo__native_layer_norm_cuda_float16"
        # onnxruntime.capi.onnxruntime_pybind11_state.NotImplemented: [ONNXRuntimeError] : 9 :
        # NOT_IMPLEMENTED : Could not find an implementation for SplitToSequence(11) node with name '_inlfunc_aten_split_n0'
        "test_output_match_opinfo__split_cuda_bool"
        "test_output_match_opinfo__split_list_args_cuda_bool"
        # onnxruntime.capi.onnxruntime_pybind11_state.NotImplemented: [ONNXRuntimeError] : 9 :
        # NOT_IMPLEMENTED : Could not find an implementation for SplitToSequence(11) node with name '_inlfunc_aten_split_with_sizes_n0'
        "test_output_match_opinfo__split_with_sizes_cuda_bool"

        # AssertionError: ONNX model is invalid
        # onnx.onnx_cpp2py_export.shape_inference.InferenceError: [ShapeInferenceError] Inference error(s):
        # (op_type:ConstantOfShape, node name: node_ConstantOfShape_67):
        # [TypeInferenceError] Inferred elem type differs from existing elem type: (FLOAT) vs (INT64)
        "test_output_match_opinfo__ops_aten__scaled_dot_product_efficient_attention_cuda_float32"

        # RuntimeError: FlashAttention only support fp16 and bf16 data type
        "test_output_match_opinfo__ops_aten__scaled_dot_product_flash_attention_cuda_float32"

        # Unexpected success
        "test_output_match_opinfo__ops_aten_col2im_cuda_float16"
        "test_output_match_opinfo__sort_cuda_float16"

        # RuntimeError: expected scalar type Int but found Float
        "test_output_match_opinfo__ops_aten_fake_quantize_per_tensor_affine_cuda_float16"
        "test_output_match_opinfo__ops_aten_fake_quantize_per_tensor_affine_cuda_float32"
      ]
      ++ lib.optionals (pythonAtLeast "3.14") [
        # TypeError: Expecting a type not f<class 'typing.Union'> for typeinfo
        "TestOutputConsistencyFullGraphCUDA"
      ];
  };

  meta = {
    description = "Naturally author ONNX functions and models using a subset of Python";
    homepage = "https://github.com/microsoft/onnxscript";
    changelog = "https://github.com/microsoft/onnxscript/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
