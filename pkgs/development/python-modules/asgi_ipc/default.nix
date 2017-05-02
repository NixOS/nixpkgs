{ stdenv, buildPythonPackage, fetchurl,
  asgiref, msgpack, posix_ipc
}:
buildPythonPackage rec {
  name = "asgi_ipc-${version}";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://pypi/a/asgi_ipc/${name}.tar.gz";
    sha256 = "1dm8xvm1z28f421ck1ympxsq2sjm9xb7dla6p8yd2bz6gn6p5h7v";
  };

  propagatedBuildInputs = [ asgiref msgpack posix_ipc ];

  meta = with stdenv.lib; {
    description = "Posix IPC-backed ASGI channel layer implementation";
    license = licenses.bsd3;
    homepage = http://github.com/django/asgi_ipc/;
  };
}
