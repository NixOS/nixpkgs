{
  lib,
  aiohttp,
  aiomcache,
  buildPythonPackage,
  fetchFromGitHub,
  marshmallow,
  msgpack,
  pkgs,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  redis,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiocache";
  version = "0.12.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiocache";
    tag = "v${version}";
    hash = "sha256-4QYCRXMWlt9fsiWgUTc2pKzXG7AG/zGmd4HT5ggIZNM=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    redis = [ redis ];
    memcached = [ aiomcache ];
    msgpack = [ msgpack ];
  };

  nativeCheckInputs = [
    aiohttp
    marshmallow
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
    # TypeError: object MagicMock can't be used in 'await' expression
    "--deselect=tests/ut/backends/test_redis.py::TestRedisBackend::test_close"
  ];

  disabledTests =
    [
      # Test calls apache benchmark and fails, no usable output
      "test_concurrency_error_rates"
    ]
    ++ lib.optionals (pythonAtLeast "3.13") [
      # https://github.com/aio-libs/aiocache/issues/863
      "test_cache_write_doesnt_wait_for_future"
    ];

  disabledTestPaths = [
    # Benchmark and performance tests are not relevant for Nixpkgs
    "tests/performance/"
  ];

  preCheck = ''
    # Note for Darwin: unless the output is redirected, the parent process becomes launchd.
    # In case of a test failure, that prevents killing the Redis process,
    # hanging the build forever (that would happen before postCheck).
    ${pkgs.redis}/bin/redis-server >/dev/null 2>&1 &
    REDIS_PID=$!
    MAX_RETRIES=30
    RETRY_COUNT=0
    until ${pkgs.redis}/bin/redis-cli --scan || [ $RETRY_COUNT -eq $MAX_RETRIES ]; do
      echo "Waiting for redis to be ready"
      sleep 1
      RETRY_COUNT=$((RETRY_COUNT + 1))
    done
    if [ $RETRY_COUNT -eq $MAX_RETRIES ]; then
      echo "Redis failed to start after $MAX_RETRIES retries"
      exit 1
    fi

    ${lib.getBin pkgs.memcached}/bin/memcached >/dev/null 2>&1 &
    MEMCACHED_PID=$!
  '';

  postCheck = ''
    kill $REDIS_PID
    kill $MEMCACHED_PID
  '';

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "aiocache" ];

  meta = with lib; {
    description = "Python API Rate Limit Decorator";
    homepage = "https://github.com/aio-libs/aiocache";
    changelog = "https://github.com/aio-libs/aiocache/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
