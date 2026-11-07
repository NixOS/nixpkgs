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
  version = "3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rq";
    repo = "rq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xLl667lQ0IcyCEUmo2BvdvvOQNYpRIzq3IvILXe2x68=";
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

  doCheck = true;

  disabledTests = [
    # timezone mismatch
    "test_cron_string_fall_back"
    "test_cron_string_spring_forward"
    "test_get_next_enqueue_time_with_cron_string"
    "test_schedule"
  ]
  ++
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # no delay between reaping worker and checking; racy
    "test_reap_workers"
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
