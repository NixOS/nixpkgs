{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "redis";
  version = "3.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e7e0cfca8660dea8b7d5cd8c4f6c5e29e11f31158c0b0ae91a397f00e5a05a2";
  };

  # tests require a running redis
  doCheck = false;

  meta = with lib; {
    description = "Python client for Redis key-value store";
    homepage = "https://pypi.python.org/pypi/redis/";
    license = with licenses; [ mit ];
  };
}
