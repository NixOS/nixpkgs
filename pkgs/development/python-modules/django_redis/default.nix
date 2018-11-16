{ stdenv, fetchPypi, buildPythonPackage,
  mock, django, redis, msgpack }:
buildPythonPackage rec {
  pname = "django-redis";
  version = "4.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15b47faef6aefaa3f47135a2aeb67372da300e4a4cf06809c66ab392686a2155";
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
