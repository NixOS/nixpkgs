{ stdenv, buildPythonPackage, fetchurl,
  asgiref, msgpack, posix_ipc
}:
buildPythonPackage rec {
  version = "1.4.2";
  pname = "asgi_ipc";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/a/asgi_ipc/${name}.tar.gz";
    sha256 = "2403f41184405791b05e7aee570bd6ccd47e2d91845d78fe17adcf58ef48c037";
  };

  propagatedBuildInputs = [ asgiref msgpack posix_ipc ];

  meta = with stdenv.lib; {
    description = "Posix IPC-backed ASGI channel layer implementation";
    license = licenses.bsd3;
    homepage = http://github.com/django/asgi_ipc/;
  };
}
