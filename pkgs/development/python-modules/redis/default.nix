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
  version = "4.3.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3fJwcd9K3zghxPLKWdZ1JcOoLl8mi+2XuBPLT6v4eIA=";
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
    hidredis = [
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

  # tests require a running redis
  doCheck = false;

  meta = with lib; {
    description = "Python client for Redis key-value store";
    homepage = "https://pypi.python.org/pypi/redis/";
    license = with licenses; [ mit ];
  };
}
