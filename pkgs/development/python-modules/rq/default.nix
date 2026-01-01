{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  hatchling,

  # dependencies
  click,
<<<<<<< HEAD
  croniter,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "2.6.1";
=======
  version = "2.4.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-4+zP3pOiZ+r/dt9F2NyxgJsyGPIHgj9XokuPxlWyS1g=";
=======
    hash = "sha256-CtxirZg6WNQpTMoXQRvB8i/KB3r58WlKh+wjBvyVMMs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ hatchling ];

  dependencies = [
    click
<<<<<<< HEAD
    croniter
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    redis
  ];

  nativeCheckInputs = [
    addBinToPathHook
    psutil
    pytestCheckHook
    redisTestHook
    versionCheckHook
  ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
