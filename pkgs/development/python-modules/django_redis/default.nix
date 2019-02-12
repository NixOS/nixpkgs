{ stdenv, fetchPypi, buildPythonPackage,
  mock, django, redis, msgpack }:
buildPythonPackage rec {
  pname = "django-redis";
  version = "4.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rxcwnv9ik0swkwvfqdi9i9baw6n8if5pj6q63fjh4p9chw3j2xg";
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
