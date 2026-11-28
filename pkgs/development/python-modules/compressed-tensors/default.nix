{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  frozendict,
  loguru,
  pydantic,
  torch,
  transformers,

  # tests
  accelerate,
  datasets,
  nbconvert,
  nbformat,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "compressed-tensors";
  version = "0.20.1";
  pyproject = true;

  # Release on PyPI is missing the `utils` directory, which `setup.py` wants to import
  src = fetchFromGitHub {
    owner = "vllm-project";
    repo = "compressed-tensors";
    tag = finalAttrs.version;
    hash = "sha256-4ZpqAqXk6nn4IkGeXnzWheP2MBJxVqRBtjVbRSqpl9g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools_scm==8.2.0" "setuptools_scm"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    frozendict
    loguru
    pydantic
    torch
    transformers
  ];

  pythonImportsCheck = [ "compressed_tensors" ];

  nativeCheckInputs = [
    accelerate
    datasets
    nbconvert
    nbformat
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # these try to download models from HF Hub
    "test_apply_tinyllama_dynamic_activations"
    "test_compress_model"
    "test_compress_model_meta"
    "test_compressed_linear_from_linear_usage"
    "test_decompress_model"
    "test_get_observer_token_count"
    "test_kv_cache_quantization"
    "test_load_compressed_sharded"
    "test_model_forward_pass"
    "test_save_compressed_model"
    "test_target_prioritization"
    "test_expand_targets_with_llama_stories"
  ]
  ++ lib.optionals (!torch.cudaSupport) [
    # AssertionError: Torch not compiled with CUDA enabled
    "test_all_functions_with_regex"
    "test_apply_config_detects_deepseekv3_attention_and_hooks"
    "test_attention_cache"
    "test_complex_model_matching"
    "test_correctness_model"
    "test_custom_mtp_prefix"
    "test_index_updated"
    "test_initialize_module_for_quantization_offloaded"
    "test_match_quantizable_tensors"
    "test_memory_sharing"
    "test_missing_dest_files_raises"
    "test_mtp_tensors_saved_correctly"
    "test_narrow_match_false_when_neither_matches"
    "test_narrow_match_false_when_parent_also_matches"
    "test_narrow_match_iterable_targets_any_true"
    "test_narrow_match_top_level_behavior_documented"
    "test_narrow_match_true_child_only"
    "test_narrow_match_with_explicit_module_argument"
    "test_no_mtp_tensors_raises"
    "test_pack_fp4_non_contiguous"
    "test_pack_fp4_to_uint8"
    "test_parameter_and_module_consistency"
    "test_quantize_and_pack_fused"
    "test_quantize_backends_match"
    "test_random_matrix_device_handling"
    "test_register_parameter"
    "test_register_parameter_invalidates"
    "test_serialization"
    "test_set_item"
    "test_set_item_buffers"
    "test_single_shard_dest_creates_index"
    "test_update_offload_parameter_with_grad"

    # Float8_e4m3fn errors
    "test_compressed_model_inference_with_hook"
    "test_quantize_dequantize_matches_sequential"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
    # RuntimeError: Failed to initialize cpuinfo!
    "test_mxfp4_scales_e2e"
    "test_mxfp8_scales_e2e"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: Numerical precision error
    "test_quantization_enabled_disabled"

    # torch._inductor.exc.InductorError: ImportError: dlopen(/nix/var/nix/builds/nix-25002-542173852/torchinductor__nixbld1/xo/cxovsevcfanmw7lgoddbnyhoxes3nzlu7ecugxedaq2zr4f6b2qh.main.so, 0x0002):
    # symbol not found in flat namespace '___kmpc_barrier'
    "test_compress_decompress_module"
  ];

  disabledTestPaths = [
    # these try to download models from HF Hub
    "tests/test_quantization/lifecycle/test_apply.py"
    "tests/test_quantization/test_quant_config.py::test_map_to_checkpoint_names"

    # AttributeError: 'NoneType' object has no attribute 'type'
    "tests/test_compressors/distributed/test_distributed_compression.py"
    "tests/test_compressors/distributed/test_module_parallel.py"
    "tests/test_compressors/model_compressors/test_model_compressor_distributed.py"
    "tests/test_offload"
  ]
  ++ lib.optionals (!torch.cudaSupport) [
    # AssertionError: Torch not compiled with CUDA enabled
    "tests/test_compressors/test_compress_decompress_module.py"
    "tests/test_transform/utils/test_hadamard.py"
    "tests/test_utils/test_match.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: Torch not compiled with CUDA enabled
    "tests/test_quantization"

    # UnboundLocalError: cannot access local variable 'a'...
    "tests/test_entrypoints/convert/test_convert_memory.py"
  ];

  meta = {
    description = "Safetensors extension to efficiently store sparse quantized tensors on disk";
    homepage = "https://github.com/vllm-project/compressed-tensors";
    changelog = "https://github.com/vllm-project/compressed-tensors/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
