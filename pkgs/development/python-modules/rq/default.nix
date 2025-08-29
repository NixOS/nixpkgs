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
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "rq";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    tag = "v${version}";
    hash = "sha256-CtxirZg6WNQpTMoXQRvB8i/KB3r58WlKh+wjBvyVMMs=";
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
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  __darwinAllowLocalNetworking = true;

  # redisTestHook does not work on darwin-x86_64
  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64);

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
