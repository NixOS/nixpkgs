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
  pythonOlder,
  redis,
  redisTestHook,
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
    memcachedTestHook
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
    redisTestHook
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
