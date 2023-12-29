{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonAtLeast
, pythonOlder
, pytestCheckHook
, setuptools
, numpy
, packaging
, psutil
, pyyaml
, torch
, evaluate
, parameterized
, transformers
}:

buildPythonPackage rec {
  pname = "accelerate";
  version = "0.24.1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DKyFb+4DUMhVUwr+sgF2IaJS9pEj2o2shGYwExfffWg=";
  };

  patches = [
    # https://github.com/huggingface/accelerate/pull/2121
    (fetchpatch {
      name = "fix-import-error-without-torch_distributed.patch";
      url = "https://github.com/huggingface/accelerate/commit/42048092eabd67a407ea513a62f2acde97079fbc.patch";
      hash = "sha256-9lvnU6z5ZEFc5RVw2bP0cGVyrwAp/pxX4ZgnmCN7qH8=";
    })
  ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    numpy
    packaging
    psutil
    pyyaml
    torch
  ];

  nativeCheckInputs = [
    evaluate
    parameterized
    pytestCheckHook
    transformers
  ];
  preCheck = ''
    export HOME=$(mktemp -d)
    export PATH=$out/bin:$PATH
  '';
  pytestFlagsArray = [ "tests" ];
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

    # set the environment variable, CC, which conflicts with standard environment
    "test_patch_environment_key_exists"
  ] ++ lib.optionals (stdenv.isLinux && stdenv.isAarch64) [
    # usual aarch64-linux RuntimeError: DataLoader worker (pid(s) <...>) exited unexpectedly
    "CheckpointTest"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    # RuntimeError: torch_shm_manager: execl failed: Permission denied
    "CheckpointTest"
  ] ++ lib.optionals (pythonAtLeast "3.11") [
    # python3.11 not yet supported for torch.compile
    "test_dynamo_extract_model"
  ];

  disabledTestPaths = lib.optionals (!(stdenv.isLinux && stdenv.isx86_64)) [
    # numerous instances of torch.multiprocessing.spawn.ProcessRaisedException:
    "tests/test_cpu.py"
    "tests/test_grad_sync.py"
    "tests/test_metrics.py"
    "tests/test_scheduler.py"
  ];

  pythonImportsCheck = [
    "accelerate"
  ];

  meta = with lib; {
    homepage = "https://huggingface.co/docs/accelerate";
    description = "A simple way to train and use PyTorch models with multi-GPU, TPU, mixed-precision";
    changelog = "https://github.com/huggingface/accelerate/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
    mainProgram = "accelerate";
  };
}
