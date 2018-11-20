{ stdenv, fetchPypi, buildPythonPackage,
  mock, django, redis, msgpack }:
buildPythonPackage rec {
  pname = "django-redis";
  version = "4.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "93fc0f73b0c1736546a979a4996826b2c430f56f7e4176df40ef53b9cb0e4f36";
  };

  doCheck = false;

  buildInputs = [ mock ];

  propagatedBuildInputs = [
    django
    redis
    msgpack
  ];

  meta = with stdenv.lib; {
    description = "Full featured redis cache backend for Django";
    homepage = https://github.com/niwibe/django-redis;
    license = licenses.bsd3;
  };
}
