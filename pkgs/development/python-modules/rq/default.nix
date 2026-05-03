{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  pythonAtLeast,

  # build-system
  hatchling,

  # dependencies
  click,
  croniter,
  redis,

  # tests
  addBinToPathHook,
  psutil,
  pytestCheckHook,
  redisTestHook,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "rq";
  version = "2.8";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZO67rsqub9hBUt4XMqrx+P7Dj1dEKD9zp4O5x1Kehe0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    croniter
    redis
  ];

  nativeCheckInputs = [
    addBinToPathHook
    psutil
    pytestCheckHook
    redisTestHook
    versionCheckHook
  ];

  preCheck = ''
    redisTestPort=6379
  '';

  __darwinAllowLocalNetworking = true;

  # redisTestHook does not work on darwin-x86_64
  doCheck = !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64);

  disabledTests =
    lib.optionals
      ((pythonAtLeast "3.14") && stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64)
      [
        # AssertionError
        "test_create_job_with_ttl_should_expire"
        "test_execution_order_with_dual_dependency"
        "test_execution_order_with_sole_dependency"
        "test_sigint_handling"
        "test_successful_job_repeat"
        "test_suspend_worker_execution"
        "test_work"
      ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # PermissionError: [Errno 13] Permission denied: '/tmp/rq-tests.txt'
      "test_deleted_jobs_arent_executed"
      "test_suspend_worker_execution"
    ];

  pythonImportsCheck = [ "rq" ];

  meta = {
    description = "Library for creating background jobs and processing them";
    homepage = "https://github.com/nvie/rq/";
    changelog = "https://github.com/rq/rq/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mrmebelman ];
  };
})
