{ stdenv, buildPythonPackage, fetchurl,
  asgiref, msgpack, posix_ipc
}:
buildPythonPackage rec {
  version = "1.4.0";
  pname = "asgi_ipc";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/a/asgi_ipc/${name}.tar.gz";
    sha256 = "1bae453d771eb92c0ec558b826fc0bce75a2a61bf21187784d4e4dc11710e588";
  };

  propagatedBuildInputs = [ asgiref msgpack posix_ipc ];

  meta = with stdenv.lib; {
    description = "Posix IPC-backed ASGI channel layer implementation";
    license = licenses.bsd3;
    homepage = http://github.com/django/asgi_ipc/;
  };
}
