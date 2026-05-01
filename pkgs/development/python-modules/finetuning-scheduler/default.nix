{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  pytorch-lightning,
  torch,

  # tests
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage (finalAttrs: {
  pname = "finetuning-scheduler";
  version = "2.10.0.post0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "speediedan";
    repo = "finetuning-scheduler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OeIpbxEjhvUzToy1jH9JcontSMfeozFjisTJCa0f4P0=";
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
  enabledTestPaths = [ "tests" ];
  disabledTests = [
    # AssertionError: assert 'lightning @ git+' in 'lightning>=2.5.0,<2.5.6'
    "test_get_lightning_requirement"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # RuntimeError: torch.compile is not supported on Python 3.14+
    "test_fts_dynamo_enforce_p0"
    "test_fts_dynamo_resume"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) [
    # slightly exceeds numerical tolerance on aarch64-linux:
    "test_fts_frozen_bn_track_running_stats"
  ];

  pythonImportsCheck = [ "finetuning_scheduler" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "PyTorch Lightning extension for foundation model experimentation with flexible fine-tuning schedules";
    homepage = "https://finetuning-scheduler.readthedocs.io";
    changelog = "https://github.com/speediedan/finetuning-scheduler/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
