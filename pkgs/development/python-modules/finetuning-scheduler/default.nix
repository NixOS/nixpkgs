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
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "speediedan";
    repo = "finetuning-scheduler";
    rev = "refs/tags/v${version}";
    hash = "sha256-uSFGZseSJv519LpaddO6yP6AsIMZutEA0Y7Yr+mEWTQ=";
  };

  build-system = [ setuptools ];

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
    ++ lib.optionals (stdenv.isAarch64 && stdenv.isLinux) [
      # slightly exceeds numerical tolerance on aarch64-linux:
      "test_fts_frozen_bn_track_running_stats"
    ];

  pythonImportsCheck = [ "finetuning_scheduler" ];

  meta = {
    description = "PyTorch Lightning extension for foundation model experimentation with flexible fine-tuning schedules";
    homepage = "https://finetuning-scheduler.readthedocs.io";
    changelog = "https://github.com/speediedan/finetuning-scheduler/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
    # "No module named 'torch._C._distributed_c10d'; 'torch._C' is not a package" at import time:
    broken = stdenv.isDarwin;
  };
}
