{ lib
, aiohttp
, aiomcache
, buildPythonPackage
, fetchFromGitHub
, marshmallow
, msgpack
, pkgs
, pythonOlder
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, redis
, setuptools
}:

buildPythonPackage rec {
  pname = "aiocache";
  version = "0.12.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiocache";
    rev = "refs/tags/v${version}";
    hash = "sha256-yvXDNJL8uxReaU81klVWudJwh1hmvg5GeeILcNpm/YA=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov=aiocache --cov=tests/ --cov-report term" ""
  '';

  build-system = [
    setuptools
  ];

  optional-dependencies = {
    redis = [
      redis
    ];
    memcached = [
      aiomcache
    ];
    msgpack = [
      msgpack
    ];
  };

  nativeCheckInputs = [
    aiohttp
    marshmallow
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
    # TypeError: object MagicMock can't be used in 'await' expression
    "--deselect=tests/ut/backends/test_redis.py::TestRedisBackend::test_close"
  ];

  disabledTests = [
    # calls apache benchmark and fails, no usable output
    "test_concurrency_error_rates"
  ];

  preCheck = ''
    ${lib.getBin pkgs.redis}/bin/redis-server &
    REDIS_PID=$!

    ${lib.getBin pkgs.memcached}/bin/memcached &
    MEMCACHED_PID=$!
  '';

  postCheck = ''
    kill $REDIS_PID
    kill $MEMCACHED_PID
  '';

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "aiocache"
  ];

  meta = with lib; {
    description = "Python API Rate Limit Decorator";
    homepage = "https://github.com/aio-libs/aiocache";
    changelog = "https://github.com/aio-libs/aiocache/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
