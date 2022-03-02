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
  version = "4.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HZoM34n92T+EJhcz4k9Vp7vUE6myGf2vVuPnKMqaIwY=";
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
