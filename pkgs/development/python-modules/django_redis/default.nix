{ stdenv, fetchPypi, buildPythonPackage,
  mock, django, redis, msgpack }:
buildPythonPackage rec {
  pname = "django-redis";
  version = "4.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "306589c7021e6468b2656edc89f62b8ba67e8d5a1c8877e2688042263daa7a63";
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
    homepage = "https://github.com/niwibe/django-redis";
    license = licenses.bsd3;
  };
}
