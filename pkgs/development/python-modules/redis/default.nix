{ fetchPypi, buildPythonPackage }:
buildPythonPackage rec {
  pname = "redis";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ba8612bbfd966dea8c62322543fed0095da2834dbd5a7c124afbc617a156aa7";
  };

  # tests require a running redis
  doCheck = false;

  meta = {
    description = "Python client for Redis key-value store";
    homepage = "https://pypi.python.org/pypi/redis/";
  };
}
