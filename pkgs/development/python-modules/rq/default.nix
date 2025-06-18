{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  fetchpatch,

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
  version = "2.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    tag = "v${version}";
    hash = "sha256-NUs544J/pC2QNyR2aIlac2P06so7JmB2P6FB/gmR7wI=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/rq/rq/commit/18c0f30c6aa0de2c55fba64105b1cb0495d728cf.patch";
      hash = "sha256-woWW8SkKXrMyDW+tY+ItxO/tuHHuuZhW+OJxwTTZucI=";
    })
  ];

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
