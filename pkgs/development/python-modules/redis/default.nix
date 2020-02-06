{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "redis";
  version = "3.3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d0fc278d3f5e1249967cba2eb4a5632d19e45ce5c09442b8422d15ee2c22cc2";
  };

  # tests require a running redis
  doCheck = false;

  meta = with lib; {
    description = "Python client for Redis key-value store";
    homepage = "https://pypi.python.org/pypi/redis/";
    license = with licenses; [ mit ];
  };
}
