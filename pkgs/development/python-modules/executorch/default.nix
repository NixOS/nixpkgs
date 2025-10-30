{
  lib,
  stdenv,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  gitMinimal,

  # build-system
  certifi,
  cmake,
  packaging,
  pyyaml,
  setuptools,
  zstd,

  # dependencies
  # coremltools, (unpackaged)
  expecttest,
  flatbuffers,
  hydra-core,
  hypothesis,
  kgb,
  mpmath,
  numpy,
  omegaconf,
  pandas,
  parameterized,
  pytorch-tokenizers,
  ruamel-yaml,
  scikit-learn,
  sympy,
  tabulate,
  torch,
  torchao,
  typing-extensions,

  # tests
  pytest-json-report,
  pytest-rerunfailures,
  pytestCheckHook,
  torchaudio,
  torchtune,
  transformers,
  writableTmpDirAsHomeHook,
  yaspin,
}:
let
  kleidiai-source = fetchFromGitHub {
    owner = "ARM-software";
    repo = "kleidiai";
    # Defined in backends/xnnpack/third-party/XNNPACK/cmake/DownloadKleidiAI.cmake
    rev = "45bf06030727ce049793ce6749e943cc2ea896fe";
    hash = "sha256-xNAPg7OfJAR8dsSEElb5uT+OgaLjtLVdvpVTgMWybU8=";
  };
in
buildPythonPackage rec {
  pname = "executorch";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "executorch";
    tag = "v${version}";

    # The ExecuTorch repo must be cloned into a directory named exactly `executorch`.
    # See https://github.com/pytorch/executorch/issues/6475 for progress on a fix for this restriction.
    name = "executorch";

    fetchSubmodules = true;
    hash = "sha256-h+nmipFDO/cdPTQXrjM5EkH//wHKBAvlDIp6SBbGN/8=";
  };
  # src = /home/gaetan/nix/nixpkgs-packages/executorch;

  postPatch =
    # Hardcode the default flatc binary path to the nixpkgs flatc
    ''
      substituteInPlace exir/_serialize/_flatbuffer.py \
        --replace-fail \
          'flatc_path = "flatc"' \
          'flatc_path = "${lib.getExe pkgs.flatbuffers}"'
    ''
    # Relax build-system dependencies
    + ''
      substituteInPlace pyproject.toml \
        --replace-fail '"pip>=23",' "" \
        --replace-fail "cmake>=3.29,<4.0.0" "cmake"
    ''
    # CMake 4 dropped support of versions lower than 3.5, versions lower than 3.10 are deprecated.
    # https://github.com/NixOS/nixpkgs/issues/445447
    + ''
      substituteInPlace backends/xnnpack/third-party/pthreadpool/CMakeLists.txt \
        --replace-fail \
          "CMAKE_MINIMUM_REQUIRED(VERSION 3.5 FATAL_ERROR)" \
          "CMAKE_MINIMUM_REQUIRED(VERSION 3.10 FATAL_ERROR)"
    '';

  env = {
    BUILD_VERSION = version;
  }
  // lib.optionalAttrs (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) {
    CMAKE_ARGS = toString [
      # KleidiAI is automatically enabled on aarch64-linux
      # https://github.com/google/XNNPACK/blob/3131afead790c5c69a9aa12273dfc40399789ad7/CMakeLists.txt#L298-L301
      (lib.cmakeFeature "KLEIDIAI_SOURCE_DIR" "${kleidiai-source}")
    ];
  };

  build-system = [
    certifi
    cmake
    packaging
    pyyaml
    setuptools
    zstd
  ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    gitMinimal
  ];

  pythonRemoveDeps = [
    # unpackaged
    "coremltools"

    # Test dependencies that should not be listed in runtime dependencies
    "pytest"
    "pytest-json-report"
    "pytest-rerunfailures"
    "pytest-xdist"
  ];
  pythonRelaxDeps = [
    "torchao"
  ];
  dependencies = [
    # coremltools (unpackaged)
    expecttest
    flatbuffers
    hydra-core
    hypothesis
    kgb
    mpmath
    numpy
    omegaconf
    packaging
    pandas
    parameterized
    pytorch-tokenizers
    pyyaml
    ruamel-yaml
    scikit-learn
    sympy
    tabulate
    torch
    torchao
    typing-extensions
  ];

  pythonImportsCheck = [ "executorch" ];

  nativeCheckInputs = [
    pytest-json-report
    pytest-rerunfailures
    pytestCheckHook
    torchaudio
    torchtune
    transformers
    writableTmpDirAsHomeHook
    yaspin
  ];

  disabledTestPaths = [
    # Require unpackaged coremltools
    "backends/apple/coreml/*"
    "export/tests/test_target_recipes.py"

    # Try to download models from HuggingFace hub
    "extension/llm/tokenizers/test/test_hf_tokenizer.py"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Fatal Python error: Segmentation fault
    "examples/models/llama3_2_vision/preprocess/test_preprocess.py"
    "exir/tests/test_joint_graph.py"
    "extension/llm/custom_ops/test_quantized_sdpa.py"
    "extension/llm/custom_ops/test_sdpa_with_kv_cache.py"
    "extension/llm/export/test_export_passes.py"
  ];

  disabledTests = [
    # RuntimeError: Failed to execute method forward, error: 0x20
    # [method.cpp:70] Backend BackendWithCompilerDemo is not registered
    "test_compatibility_in_runtime"
    "test_compatibility_in_runtime_edge_program_manager"
    "test_emit_lowered_backend_module_end_to_end"
    "test_multi_method_end_to_end"

    # AssertionError (Numerical comparison fails)
    "test_sdpa_with_cache_seq_len_13"
    "test_sdpa_with_custom_quantized_seq_len_130_gqa"

    # Try to download models from the internet
    "test_all_models_with_recipes"
    "test_dl3_export_to_executorch"
    "test_efficient_sam_export_to_executorch"
    "test_ic3_export_to_executorch"
    "test_mobilenet_v3"
    "test_mobilenet_v3_xnnpack"
    "test_mv2_export_to_executorch"
    "test_mv3_export_to_executorch"
    "test_resnet18_export_to_executorch"
    "test_resnet50_export_to_executorch"
    "test_vit_export_to_executorch"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Fatal Python error: Segmentation fault
    "test_attention_executorch"
    "test_attention_torch_cond_executorch"
    "test_program_data_separation"
    "test_remove_unused_parameters_nested_e2e_to_edge"
    "test_remove_unused_parameters_simple_e2e_to_edge"
    "test_resnet18"
    "test_tile_positional_embedding_et"
    "test_tiled_token_positional_embedding_et"
    "test_w2l_export_to_executorch"

    # AssertionError: False is not true
    # [method.cpp:75] Backend XnnpackBackend is not available.
    "test_backend_is_available"

    # RuntimeError: Failed to execute method forward, error: 0x20
    "test_8a4w_recipe"
    "test_add_with_alpha"
    "test_add_with_alpha"
    "test_basic_recipe"
    "test_channel_last_before_linear"
    "test_constant_pad_nd"
    "test_contiguous_before_conv"
    "test_conv_add_conv_output"
    "test_conv_linear_dim_order_swap_partitioner"
    "test_conv_linear_dim_order_swaps"
    "test_dq_conv2d"
    "test_dq_conv2d_parallel"
    "test_dq_conv2d_seq"
    "test_dq_conv2d_transpose"
    "test_dq_conv2d_transpose_parallel"
    "test_dq_conv2d_transpose_seq"
    "test_dtype_and_memory_format_conversion"
    "test_dtype_and_memory_format_with_linear"
    "test_fp16_abs"
    "test_fp16_abs_legacy_mode"
    "test_fp16_add"
    "test_fp16_avgpool2d"
    "test_fp16_cat2"
    "test_fp16_cat3"
    "test_fp16_cat4"
    "test_fp16_cat5"
    "test_fp16_cat_gt_5"
    "test_fp16_ceil"
    "test_fp16_clamp"
    "test_fp16_conv1d"
    "test_fp16_conv2d"
    "test_fp16_div"
    "test_fp16_exp"
    "test_fp16_floor"
    "test_fp16_gelu"
    "test_fp16_hardswish"
    "test_fp16_leaky_relu"
    "test_fp16_log"
    "test_fp16_max_dim_no_indices"
    "test_fp16_maximum"
    "test_fp16_maxpool2d"
    "test_fp16_mean_dim"
    "test_fp16_minimum"
    "test_fp16_mul"
    "test_fp16_negate"
    "test_fp16_permute"
    "test_fp16_pow2"
    "test_fp16_rsqrt"
    "test_fp16_sigmoid"
    "test_fp16_slice_copy"
    "test_fp16_softmax"
    "test_fp16_sqrt"
    "test_fp16_square"
    "test_fp16_static_constant_pad_functional"
    "test_fp16_sub"
    "test_fp16_tanh"
    "test_fp32_abs"
    "test_fp32_abs_legacy_mode"
    "test_fp32_add"
    "test_fp32_add_constant"
    "test_fp32_add_relu"
    "test_fp32_avgpool2d"
    "test_fp32_cat2"
    "test_fp32_cat3"
    "test_fp32_cat4"
    "test_fp32_cat5"
    "test_fp32_cat_gt_5"
    "test_fp32_cat_negative_dim"
    "test_fp32_ceil"
    "test_fp32_clamp"
    "test_fp32_clamp_lower"
    "test_fp32_clamp_upper"
    "test_fp32_conv1d"
    "test_fp32_conv1d_batchnorm_seq"
    "test_fp32_conv2d"
    "test_fp32_conv2d_bn"
    "test_fp32_conv2d_bn_hardtanh_mean_sequence"
    "test_fp32_conv2d_depthwise"
    "test_fp32_conv2d_permute"
    "test_fp32_conv2d_seq"
    "test_fp32_conv2d_single_int_params"
    "test_fp32_div"
    "test_fp32_div_single_input"
    "test_fp32_exp"
    "test_fp32_floor"
    "test_fp32_gelu"
    "test_fp32_hardswish"
    "test_fp32_hardswish_functional"
    "test_fp32_hardtanh"
    "test_fp32_hardtanh_bound"
    "test_fp32_leaky_relu"
    "test_fp32_leaky_relu_functional"
    "test_fp32_log"
    "test_fp32_lstm"
    "test_fp32_max_dim_no_indices"
    "test_fp32_maximum"
    "test_fp32_maximum_broadcast"
    "test_fp32_maxpool2d"
    "test_fp32_maxpool2d_ceilmode"
    "test_fp32_mean_dim"
    "test_fp32_minimum"
    "test_fp32_mul"
    "test_fp32_negate"
    "test_fp32_permute"
    "test_fp32_permute_copy"
    "test_fp32_permute_negative_dim"
    "test_fp32_pow2"
    "test_fp32_prelu"
    "test_fp32_relu"
    "test_fp32_rsqrt"
    "test_fp32_sigmoid"
    "test_fp32_slice_copy"
    "test_fp32_slice_copy_default_start"
    "test_fp32_slice_copy_memory_format"
    "test_fp32_softmax"
    "test_fp32_sqrt"
    "test_fp32_square"
    "test_fp32_static_constant_pad_functional"
    "test_fp32_static_constant_pad_nhwc"
    "test_fp32_static_resize_bilinear2d"
    "test_fp32_static_resize_bilinear2d_with_align_corners"
    "test_fp32_sub"
    "test_fp32_tanh"
    "test_int8_dynamic_quant_recipe"
    "test_int8_static_quant_recipe"
    "test_linear_conv_dim_order_swaps"
    "test_lstm_with_force_non_static_weights_for_f32_linear"
    "test_nhwc_nchw_input_on_nhwc_op"
    "test_qs8_add"
    "test_qs8_add2"
    "test_qs8_add3"
    "test_qs8_add_constant"
    "test_qs8_add_relu"
    "test_qs8_add_relu_seq"
    "test_qs8_cat2"
    "test_qs8_cat3"
    "test_qs8_cat4"
    "test_qs8_cat5"
    "test_qs8_cat_gt_5"
    "test_qs8_cat_with_empty_tensor"
    "test_qs8_clamp"
    "test_qs8_conv1d"
    "test_qs8_conv1d_batchnorm_seq"
    "test_qs8_conv2d_bn"
    "test_qs8_conv2d_depthwise"
    "test_qs8_conv2d_dw_relu"
    "test_qs8_conv2d_per_channel"
    "test_qs8_conv2d_relu"
    "test_qs8_conv2d_relu_multi_users"
    "test_qs8_conv2d_relu_seq"
    "test_qs8_conv2d_seq"
    "test_qs8_conv2d_test"
    "test_qs8_conv_transpose_2d_quantize_per_channel_multi_axis"
    "test_qs8_dequantize_per_tenstor"
    "test_qs8_hardtanh"
    "test_qs8_maxpool2d"
    "test_qs8_mean_dim"
    "test_qs8_mul"
    "test_qs8_mul2"
    "test_qs8_mul_functional"
    "test_qs8_mul_relu"
    "test_qs8_permute"
    "test_qs8_permute_copy"
    "test_qs8_quantize_per_tensor"
    "test_qs8_static_constant_pad_2d"
    "test_qs8_static_constant_pad_functional"
    "test_quantized_to_copy"
    "test_three_outputs_model"
    "test_two_conv_add"
  ];

  meta = {
    description = "On-device AI across mobile, embedded and edge for PyTorch";
    homepage = "https://github.com/pytorch/executorch";
    changelog = "https://github.com/pytorch/executorch/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
