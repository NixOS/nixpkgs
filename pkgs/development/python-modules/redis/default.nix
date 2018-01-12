{ stdenv, fetchPypi, buildPythonPackage }:
buildPythonPackage rec {
  pname = "redis";
  version = "2.10.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03vcgklykny0g0wpvqmy8p6azi2s078317wgb2xjv5m2rs9sjb52";
  };

  # tests require a running redis
  doCheck = false;

  meta = {
    description = "Python client for Redis key-value store";
    homepage = "https://pypi.python.org/pypi/redis/";
  };
}
