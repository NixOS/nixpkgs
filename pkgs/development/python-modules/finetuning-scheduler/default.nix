{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  pytorch-lightning,
  torch,

  # tests
  pythonOlder,
  pythonAtLeast,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "finetuning-scheduler";
  version = "2.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "speediedan";
    repo = "finetuning-scheduler";
    tag = "v${version}";
    hash = "sha256-6WRKDYug7eVaTSY2R2jBcj9o/984mqKZZi36XRT7KyI=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/speediedan/finetuning-scheduler/commit/78e6e225f353d1ba95db05d7fc6ff541859ed6a2.patch";
      hash = "sha256-7mbtsaHrnHph8lvuwhBGqxPQimbZcbGeyBYXzApFPn4=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools<77.0.0" "setuptools"
  '';

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
  disabledTests =
    lib.optionals (pythonOlder "3.12") [
      # torch._dynamo.exc.BackendCompilerFailed: backend='inductor' raised:
      # LoweringException: ImportError: cannot import name 'triton_key' from 'triton.compiler.compiler'
      "test_fts_dynamo_enforce_p0"
      "test_fts_dynamo_resume"
      "test_fts_dynamo_intrafit"
    ]
    ++ lib.optionals (pythonAtLeast "3.13") [
      # RuntimeError: Dynamo is not supported on Python 3.13+
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
    changelog = "https://github.com/speediedan/finetuning-scheduler/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
