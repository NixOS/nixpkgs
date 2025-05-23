{
  lib,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  async-timeout,
  deprecated,
  packaging,
  typing-extensions,

  # extras: hiredis
  hiredis,

  # extras: ocsp
  cryptography,
  pyopenssl,
  requests,
}:

buildPythonPackage rec {
  pname = "redis";
  version = "6.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ySjiZ61p0waa8oqYI6B3Ju33LH43dk9D3AEj83kowHU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    async-timeout
    deprecated
    packaging
    typing-extensions
  ];

  optional-dependencies = {
    hiredis = [ hiredis ];
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

  meta = with lib; {
    description = "Python client for Redis key-value store";
    homepage = "https://github.com/redis/redis-py";
    changelog = "https://github.com/redis/redis-py/releases/tag/v${version}";
    license = with licenses; [ mit ];
  };
}
