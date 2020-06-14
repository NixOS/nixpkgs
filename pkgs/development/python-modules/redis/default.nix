{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "redis";
  version = "3.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18h5b87g15x3j6pb1h2q27ri37p2qpvc9n2wgn5yl3b6m3y0qzhf";
  };

  # tests require a running redis
  doCheck = false;

  meta = with lib; {
    description = "Python client for Redis key-value store";
    homepage = "https://pypi.python.org/pypi/redis/";
    license = with licenses; [ mit ];
  };
}
