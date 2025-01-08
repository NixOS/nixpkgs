{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  pytestCheckHook,
  torch,
  pytorch-lightning,
}:

buildPythonPackage rec {
  pname = "finetuning-scheduler";
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "speediedan";
    repo = "finetuning-scheduler";
    tag = "v${version}";
    hash = "sha256-neeSATQwAaYN1QGBUXphqqJp9lP3HG2OH4aLdt1cOho=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "pytorch-lightning"
  ];

  dependencies = [
    pytorch-lightning
    torch
  ];

  # needed while lightning is installed as package `pytorch-lightning` rather than`lightning`:
  env.PACKAGE_NAME = "pytorch";

  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "tests" ];
  disabledTests =
    # torch._dynamo.exc.BackendCompilerFailed: backend='inductor' raised:
    # LoweringException: ImportError: cannot import name 'triton_key' from 'triton.compiler.compiler'
    lib.optionals (pythonOlder "3.12") [
      "test_fts_dynamo_enforce_p0"
      "test_fts_dynamo_resume"
      "test_fts_dynamo_intrafit"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) [
      # slightly exceeds numerical tolerance on aarch64-linux:
      "test_fts_frozen_bn_track_running_stats"
    ];

  pythonImportsCheck = [ "finetuning_scheduler" ];

  meta = {
    description = "PyTorch Lightning extension for foundation model experimentation with flexible fine-tuning schedules";
    homepage = "https://finetuning-scheduler.readthedocs.io";
    changelog = "https://github.com/speediedan/finetuning-scheduler/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
    badPlatforms = [
      # "No module named 'torch._C._distributed_c10d'; 'torch._C' is not a package" at import time:
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
