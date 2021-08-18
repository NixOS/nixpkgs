{ lib, fetchPypi, buildPythonPackage,
  mock, django, redis, msgpack }:
buildPythonPackage rec {
  pname = "django-redis";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "048f665bbe27f8ff2edebae6aa9c534ab137f1e8fa7234147ef470df3f3aa9b8";
  };

  doCheck = false;

  buildInputs = [ mock ];

  propagatedBuildInputs = [
    django
    redis
    msgpack
  ];

  meta = with lib; {
    description = "Full featured redis cache backend for Django";
    homepage = "https://github.com/niwibe/django-redis";
    license = licenses.bsd3;
  };
}
