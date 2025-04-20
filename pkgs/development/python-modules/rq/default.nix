{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  hatchling,

  # dependencies
  click,
  redis,

  # tests
  addBinToPathHook,
  psutil,
  pytestCheckHook,
  redisTestHook,
  sentry-sdk,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "rq";
  version = "2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    tag = "v${version}";
    hash = "sha256-RuqLfPEwdwfJo+mdY4vB3lpyGkbP/GQDfRU+TmUur3s=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    redis
  ];

  nativeCheckInputs = [
    addBinToPathHook
    psutil
    pytestCheckHook
    redisTestHook
    sentry-sdk
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  __darwinAllowLocalNetworking = true;

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # PermissionError: [Errno 13] Permission denied: '/tmp/rq-tests.txt'
    "test_deleted_jobs_arent_executed"
    "test_suspend_worker_execution"
  ];

  pythonImportsCheck = [ "rq" ];

  meta = {
    description = "Library for creating background jobs and processing them";
    homepage = "https://github.com/nvie/rq/";
    changelog = "https://github.com/rq/rq/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mrmebelman ];
  };
}
