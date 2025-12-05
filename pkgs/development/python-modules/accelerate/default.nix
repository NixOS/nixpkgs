{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # buildInputs
  llvmPackages,

  # build-system
  setuptools,

  # dependencies
  huggingface-hub,
  numpy,
  packaging,
  psutil,
  pyyaml,
  safetensors,
  torch,

  # tests
  addBinToPathHook,
  evaluate,
  parameterized,
  pytestCheckHook,
  transformers,
  config,
  cudatoolkit,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "accelerate";
  version = "1.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "accelerate";
    tag = "v${version}";
    hash = "sha256-PwwaQSLOm+8Hd3trM1P+jRhYyoWM3QxOe5XT99haEmg=";
  };

  buildInputs = [ llvmPackages.openmp ];

  build-system = [ setuptools ];

  dependencies = [
    huggingface-hub
    numpy
    packaging
    psutil
    pyyaml
    safetensors
    torch
  ];

  nativeCheckInputs = [
    addBinToPathHook
    evaluate
    parameterized
    pytestCheckHook
    transformers
    writableTmpDirAsHomeHook
  ];

  preCheck = lib.optionalString config.cudaSupport ''
    export TRITON_PTXAS_PATH="${lib.getExe' cudatoolkit "ptxas"}"
  '';
  enabledTestPaths = [ "tests" ];
  disabledTests = [
    # try to download data:
    "FeatureExamplesTests"
    "test_infer_auto_device_map_on_t0pp"

    # require socket communication
    "test_explicit_dtypes"
    "test_gated"
    "test_invalid_model_name"
    "test_invalid_model_name_transformers"
    "test_no_metadata"
    "test_no_split_modules"
    "test_remote_code"
    "test_transformers_model"
    "test_extract_model_keep_torch_compile"
    "test_extract_model_remove_torch_compile"
    "test_regions_are_compiled"

    # nondeterministic, tests GC behaviour by thresholding global ram usage
    "test_free_memory_dereferences_prepared_components"

    # set the environment variable, CC, which conflicts with standard environment
    "test_patch_environment_key_exists"
  ]
  ++ lib.optionals ((pythonAtLeast "3.13") || (torch.rocmSupport or false)) [
    # RuntimeError: Dynamo is not supported on Python 3.13+
    # OR torch.compile tests broken on torch 2.5 + rocm
    "test_can_unwrap_distributed_compiled_model_keep_torch_compile"
    "test_can_unwrap_distributed_compiled_model_remove_torch_compile"
    "test_convert_to_fp32"
    "test_send_to_device_compiles"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # usual aarch64-linux RuntimeError: DataLoader worker (pid(s) <...>) exited unexpectedly
    "CheckpointTest"
    # TypeError: unsupported operand type(s) for /: 'NoneType' and 'int' (it seems cpuinfo doesn't work here)
    "test_mpi_multicpu_config_cmd"
  ]
  ++ lib.optionals (!config.cudaSupport) [
    # requires ptxas from cudatoolkit, which is unfree
    "test_dynamo_extract_model"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: 'accelerate-launch /nix/store/a7vhm7b74a7bmxc35j26s9iy1zfaqjs...
    "test_accelerate_test"
    "test_init_trackers"
    "test_init_trackers"
    "test_log"
    "test_log_with_tensor"

    # After enabling MPS in pytorch, these tests started failing
    "test_accelerated_optimizer_step_was_skipped"
    "test_auto_wrap_policy"
    "test_autocast_kwargs"
    "test_automatic_loading"
    "test_backward_prefetch"
    "test_can_resume_training"
    "test_can_resume_training_checkpoints_relative_path"
    "test_can_resume_training_with_folder"
    "test_can_unwrap_model_fp16"
    "test_checkpoint_deletion"
    "test_cpu_offload"
    "test_cpu_ram_efficient_loading"
    "test_grad_scaler_kwargs"
    "test_invalid_registration"
    "test_map_location"
    "test_mixed_precision"
    "test_mixed_precision_buffer_autocast_override"
    "test_project_dir"
    "test_project_dir_with_config"
    "test_sharding_strategy"
    "test_state_dict_type"
    "test_with_save_limit"
    "test_with_scheduler"

    # torch._inductor.exc.InductorError: TypeError: cannot determine truth value of Relational
    "test_regional_compilation_cold_start"
    "test_regional_compilation_inference_speedup"

    # Fails in nixpkgs-review due to a port conflict with simultaneous python builds
    "test_config_compatibility"

    # Fails with `sandbox=false` by mis-configuring the model it's using.
    # AttributeError: 'DistributedDataParallel' object has no attribute '_ignored_modules'. Did you mean: 'named_modules'?
    "test_ignored_modules_regex"

    # Illegal instruction (x86_64) / Trace/BPT Error 5 (aarch64)
    "test_can_pickle_dataloader"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) [
    # RuntimeError: torch_shm_manager: execl failed: Permission denied
    "CheckpointTest"
  ];

  disabledTestPaths = lib.optionals (!(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64)) [
    # numerous instances of torch.multiprocessing.spawn.ProcessRaisedException:
    "tests/test_cpu.py"
    "tests/test_grad_sync.py"
    "tests/test_metrics.py"
    "tests/test_scheduler.py"
  ];

  pythonImportsCheck = [ "accelerate" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    homepage = "https://huggingface.co/docs/accelerate";
    description = "Simple way to train and use PyTorch models with multi-GPU, TPU, mixed-precision";
    changelog = "https://github.com/huggingface/accelerate/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
    mainProgram = "accelerate";
  };
}
