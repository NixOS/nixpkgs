{ stdenv, buildPythonPackage, fetchurl,
  asgiref, asgi_ipc, msgpack, six, redis, cryptography
}:
buildPythonPackage rec {
  version = "1.4.2";
  pname = "asgi_redis";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/a/asgi_redis/${name}.tar.gz";
    sha256 = "aa8e9342a3e66c4e7f9035b074f6f66b92e5f1cf8022f1446106ed6dd004a274";
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
