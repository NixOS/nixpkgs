{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder

# propagates
, async-timeout
, deprecated
, importlib-metadata
, packaging
, typing-extensions

# extras: hiredis
, hiredis

# extras: ocsp
, cryptography
, pyopenssl
, requests
}:

buildPythonPackage rec {
  pname = "redis";
  version = "4.5.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c+w12k2iZ9aEfkf2hzD91fYuLKaePvWIXGp4qTdMOJM=";
  };

  propagatedBuildInputs = [
    async-timeout
    deprecated
    packaging
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  passthru.optional-dependencies = {
    hiredis = [
      hiredis
    ];
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
