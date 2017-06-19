{ stdenv, buildPythonPackage, fetchurl,
  asgiref, asgi_ipc, msgpack, six, redis, cryptography
}:
buildPythonPackage rec {
  version = "1.4.1";
  pname = "asgi_redis";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/a/asgi_redis/${name}.tar.gz";
    sha256 = "71a6147c8b08833815993f16e2b665a0e5483fae392f03decb8da54ed0882904";
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
