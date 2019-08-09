{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "redis";
  version = "3.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18n6k113izfqsm8yysrw1a5ba6kv0vsgfz6ab5n0k6k65yvr690z";
  };

  # tests require a running redis
  doCheck = false;

  meta = with lib; {
    description = "Python client for Redis key-value store";
    homepage = "https://pypi.python.org/pypi/redis/";
    license = with licenses; [ mit ];
  };
}
