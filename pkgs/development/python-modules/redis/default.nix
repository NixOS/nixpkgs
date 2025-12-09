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
}:

buildPythonPackage rec {
  pname = "redis";
  version = "7.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "redis";
    repo = "redis-py";
    tag = "v${version}";
    hash = "sha256-EhhE2l0UdkGWhCwKAF7fuSxq4ooj75Cxwg2zXjJJRzA=";
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

  # Tests require a running redis
  doCheck = false;

  meta = {
    description = "Python client for Redis key-value store";
    homepage = "https://github.com/redis/redis-py";
    changelog = "https://github.com/redis/redis-py/releases/tag/${src.tag}";
    license = lib.licenses.mit;
  };
}
