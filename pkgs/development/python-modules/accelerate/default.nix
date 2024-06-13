{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
  pythonOlder,
  llvmPackages,
  pytest7CheckHook,
  setuptools,
  numpy,
  packaging,
  psutil,
  pyyaml,
  safetensors,
  torch,
  config,
  cudatoolkit,
  evaluate,
  parameterized,
  transformers,
}:

buildPythonPackage rec {
  pname = "accelerate";
  version = "0.30.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "accelerate";
    rev = "refs/tags/v${version}";
    hash = "sha256-E20pI5BrcTrMYrhriuOUl5/liSaQQy6eqRyCoauwb9Q=";
  };

  buildInputs = [ llvmPackages.openmp ];

  build-system = [ setuptools ];

  dependencies = [
    numpy
    packaging
    psutil
    pyyaml
    safetensors
    torch
  ];

  nativeCheckInputs = [
    evaluate
    parameterized
    pytest7CheckHook
    transformers
  ];
  preCheck =
    ''
      export HOME=$(mktemp -d)
      export PATH=$out/bin:$PATH
    ''
    + lib.optionalString config.cudaSupport ''
      export TRITON_PTXAS_PATH="${cudatoolkit}/bin/ptxas"
    '';
  pytestFlagsArray = [ "tests" ];
  disabledTests =
    [
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

      # nondeterministic, tests GC behaviour by thresholding global ram usage
      "test_free_memory_dereferences_prepared_components"

      # set the environment variable, CC, which conflicts with standard environment
      "test_patch_environment_key_exists"
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # RuntimeError: Dynamo is not supported on Python 3.12+
      "test_convert_to_fp32"
      "test_dynamo_extract_model"
      "test_send_to_device_compiles"
    ]
    ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
      # usual aarch64-linux RuntimeError: DataLoader worker (pid(s) <...>) exited unexpectedly
      "CheckpointTest"
      # TypeError: unsupported operand type(s) for /: 'NoneType' and 'int' (it seems cpuinfo doesn't work here)
      "test_mpi_multicpu_config_cmd"
    ]
    ++ lib.optionals (!config.cudaSupport) [
      # requires ptxas from cudatoolkit, which is unfree
      "test_dynamo_extract_model"
    ]
    ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
      # RuntimeError: torch_shm_manager: execl failed: Permission denied
      "CheckpointTest"
    ];

  disabledTestPaths = lib.optionals (!(stdenv.isLinux && stdenv.isx86_64)) [
    # numerous instances of torch.multiprocessing.spawn.ProcessRaisedException:
    "tests/test_cpu.py"
    "tests/test_grad_sync.py"
    "tests/test_metrics.py"
    "tests/test_scheduler.py"
  ];

  pythonImportsCheck = [ "accelerate" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    homepage = "https://huggingface.co/docs/accelerate";
    description = "Simple way to train and use PyTorch models with multi-GPU, TPU, mixed-precision";
    changelog = "https://github.com/huggingface/accelerate/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "accelerate";
  };
}
