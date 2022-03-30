{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder

# propagates
, cryptography
, deprecated
, hiredis
, importlib-metadata
, packaging
, requests
}:

buildPythonPackage rec {
  pname = "redis";
  version = "4.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Z1jQHeyBrxkbmKNczjQCZ10RVFZYTDm1AKtIWl44a7s=";
  };

  propagatedBuildInputs = [
    cryptography
    deprecated
    hiredis
    packaging
    requests
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

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
