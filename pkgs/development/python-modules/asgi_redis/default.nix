{ stdenv, buildPythonPackage, fetchPypi,
  asgiref, asgi_ipc, msgpack, six, redis, cryptography
}:
buildPythonPackage rec {
  version = "1.4.3";
  pname = "asgi_redis";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10xk7k7mcd28nb3v93mc8xa7sa6p02jnbl8idk6scr6p75jaixzi";
  };

  # Requires a redis server available
  doCheck = false;

  propagatedBuildInputs = [ asgiref asgi_ipc msgpack six redis cryptography ];

  meta = with stdenv.lib; {
    description = "Redis-backed ASGI channel layer implementation";
    license = licenses.bsd3;
    homepage = https://github.com/django/asgi_redis/;
  };
}
