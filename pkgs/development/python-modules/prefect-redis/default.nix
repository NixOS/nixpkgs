{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  prefect,
  redis,
  pytestCheckHook,
  pytest-asyncio,
  pytest-env,
  pytest-timeout,
  pytest-xdist,
  pillow,
  redisTestHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "prefect-redis";
  version = "0.2.11";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PrefectHQ";
    repo = "prefect";
    tag = "prefect-redis-${finalAttrs.version}";
    hash = "sha256-mYqQKebUDwTpELUmWDkEFSUmxwM69AOw7rJOxgUiYbM=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/integrations/prefect-redis";

  postPatch = ''
    # prefect_test_harness() waits a hardcoded 30s for its ephemeral API
    # server; each xdist worker starts one, which can take longer on
    # loaded builders
    substituteInPlace tests/conftest.py \
      --replace-fail "prefect_test_harness()" \
        "prefect_test_harness(server_startup_timeout=120)"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    prefect
    redis
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-env
    pytest-timeout
    pytest-xdist
    pillow
    redisTestHook
    writableTmpDirAsHomeHook
  ];

  # Worker count is set in preCheck instead
  dontUsePytestXdist = true;

  # redisTestHook runs Redis with its default 16 databases, and each
  # xdist worker uses database (worker index + 2), so cap at 14 workers
  preCheck = ''
    appendToVar pytestFlags "--numprocesses=$(( NIX_BUILD_CORES < 14 ? NIX_BUILD_CORES : 14 ))"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # redisTestHook binds TCP 6379 by default; darwin has no per-build
    # network namespace, so concurrent builds (e.g. python313 + python314)
    # collide on that port and the hook waits forever. Use a per-build port.
    redisTestPort=$(( 20000 + RANDOM % 20000 ))
    export PREFECT_REDIS_MESSAGING_PORT=$redisTestPort
    export TEST_REDIS_PORT=$redisTestPort
  '';

  # Upstream's 30s per-test timeout also covers the session fixture that
  # starts the Prefect server
  pytestFlags = [ "--timeout=300" ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Assert the default port, which is overridden on darwin above
    "test_redis_settings_defaults"
    "test_get_async_redis_client_defaults"
    "test_redis_settings_url_no_warning_with_defaults"
    # RedisLockManager() in the fixture uses its hardcoded localhost:6379
    "TestRedisLockManager"
  ];

  # Tests start local Redis and Prefect servers
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "prefect_redis" ];

  meta = {
    description = "Redis integration for Prefect";
    homepage = "https://github.com/PrefectHQ/prefect/tree/main/src/integrations/prefect-redis";
    changelog = "https://github.com/PrefectHQ/prefect/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
