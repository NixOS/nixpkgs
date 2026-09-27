{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  async-timeout,

  # extras: circuit_breaker
  pybreaker,

  # extras: hiredis
  hiredis,

  # extras: jwt
  pyjwt,

  # extras: ocsp
  cryptography,
  pyopenssl,
  requests,

  # extras: otel
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-sdk,

  # extras: xxhash
  xxhash,

  # tests
  numpy,
  pytest-asyncio,
  pytestCheckHook,
  redisTestHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "redis";
  version = "8.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "redis";
    repo = "redis-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-41i4oZmbWi87KBSaAAaZe2gPlCpgw6kEPne1IA3PHQM=";
  };

  build-system = [ hatchling ];

  dependencies = lib.optionals (pythonOlder "3.11") [
    async-timeout
  ];

  optional-dependencies = {
    circuit_breaker = [ pybreaker ];
    hiredis = [ hiredis ];
    jwt = [ pyjwt ];
    ocsp = [
      cryptography
      pyopenssl
      requests
    ];
    otel = [
      opentelemetry-api
      opentelemetry-exporter-otlp-proto-http
      opentelemetry-sdk
    ];
    xxhash = [ xxhash ];
  };

  pythonImportsCheck = [
    "redis"
    "redis.client"
    "redis.cluster"
    "redis.connection"
    "redis.exceptions"
    "redis.sentinel"
    "redis.utils"
  ];

  nativeCheckInputs = [
    numpy
    pytest-asyncio
    pytestCheckHook
    redisTestHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.circuit_breaker
  ++ finalAttrs.passthru.optional-dependencies.otel;

  enabledTestMarks = [
    "onlynoncluster"
  ];

  disabledTestMarks = [
    "onlycluster"
    "redismod"
  ];

  disabledTestPaths = [
    # requires Redis Sentinel
    "tests/test_asyncio/test_sentinel.py"
    "tests/test_sentinel.py"
    # FIXME package redis-entraid
    "tests/test_asyncio/test_credentials.py"
    "tests/test_credentials.py"
  ];

  disabledTests = [
    # requires a Redis cluster
    "test_readonly_invalid_cluster_state"
    # we run Valkey, not Redis
    "test_lolwut"
  ];

  # circular dependency via pybreaker
  doCheck = false;

  passthru.tests = {
    pytest = finalAttrs.finalPackage.overrideAttrs {
      doInstallCheck = true;
    };
  };

  meta = {
    description = "Python client for Redis key-value store";
    homepage = "https://github.com/redis/redis-py";
    changelog = "https://github.com/redis/redis-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
    teams = [ lib.teams.redis ];
  };
})
