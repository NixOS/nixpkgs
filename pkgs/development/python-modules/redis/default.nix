{ fetchPypi, buildPythonPackage }:
buildPythonPackage rec {
  pname = "redis";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kw3a1618pl908abiaxd41jg5z0rwyl2w2i0d8xi9zxy5437a011";
  };

  # tests require a running redis
  doCheck = false;

  meta = {
    description = "Python client for Redis key-value store";
    homepage = "https://pypi.python.org/pypi/redis/";
  };
}
