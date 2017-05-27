{ stdenv, buildPythonPackage, fetchurl,
  asgiref, asgi_ipc, msgpack, six, redis, cryptography
}:
buildPythonPackage rec {
  version = "1.4.0";
  pname = "asgi_redis";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/a/asgi_redis/${name}.tar.gz";
    sha256 = "ec137829a9ebfb0de1c034bc699240c9747b97a3eb2dc4df6c812f82290a0f9f";
  };

  # Requires a redis server available
  doCheck = false;

  propagatedBuildInputs = [ asgiref asgi_ipc msgpack six redis cryptography ];

  meta = with stdenv.lib; {
    description = "Redis-backed ASGI channel layer implementation";
    license = licenses.bsd3;
    homepage = http://github.com/django/asgi_redis/;
  };
}
