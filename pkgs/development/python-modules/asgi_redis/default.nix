{ stdenv, buildPythonPackage, fetchurl,
  asgiref, asgi_ipc, msgpack, six, redis, cryptography
}:
buildPythonPackage rec {
  version = "1.3.0";
  pname = "asgi_redis";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/a/asgi_redis/${name}.tar.gz";
    sha256 = "0zhv51w0fx3i8m0032nk9v00l6mxaswyi95yzy7p7fjww4q74ncl";
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
