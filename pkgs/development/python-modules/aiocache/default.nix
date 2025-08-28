{
  lib,
  aiohttp,
  aiomcache,
  buildPythonPackage,
  fetchFromGitHub,
  marshmallow,
  memcachedTestHook,
  msgpack,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
  pythonAtLeast,
  redis,
  redisTestHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiocache";
  version = "0.12.3";
  pyproject = true;

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
    memcachedTestHook
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    redisTestHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlags = [
    "-Wignore::DeprecationWarning"
    # Tests can time out and leave redis/valkey in an unusable state for later tests
    "-x"
  ];

  disabledTests = [
    # Test calls apache benchmark and fails, no usable output
    "test_concurrency_error_rates"
    # susceptible to timing out / short ttl
    "test_cached_stampede"
    "test_locking_dogpile_lease_expiration"
    "test_set_ttl_handle"
    "test_set_cancel_previous_ttl_handle"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # https://github.com/aio-libs/aiocache/issues/863
    "test_cache_write_doesnt_wait_for_future"
  ];

  disabledTestPaths = [
    # Benchmark and performance tests are not relevant for Nixpkgs
    "tests/performance/"
    # Full of timing-sensitive tests
    "tests/ut/backends/test_redis.py"

    # TypeError: object MagicMock can't be used in 'await' expression
    "tests/ut/backends/test_redis.py::TestRedisBackend::test_close"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "aiocache" ];

  meta = {
    description = "Asyncio cache supporting multiple backends (memory, redis, memcached, etc.)";
    homepage = "https://github.com/aio-libs/aiocache";
    changelog = "https://github.com/aio-libs/aiocache/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
}
