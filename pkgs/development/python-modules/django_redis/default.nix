{ stdenv, fetchPypi, buildPythonPackage,
  mock, django, redis, msgpack }:
buildPythonPackage rec {
  pname = "django-redis";
  version = "4.8.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5229da5b07ccb8d3e3e9ee098c0b7c03e20eba48634bc456697dd73d62c68b19";
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
