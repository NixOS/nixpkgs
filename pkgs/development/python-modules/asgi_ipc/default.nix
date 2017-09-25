{ stdenv, buildPythonPackage, fetchurl,
  asgiref, msgpack, posix_ipc
}:
buildPythonPackage rec {
  version = "1.4.1";
  pname = "asgi_ipc";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/a/asgi_ipc/${name}.tar.gz";
    sha256 = "87cc9dda476d28f335261b73f0f3070f28847718de2e64da9a80492638203e43";
  };

  propagatedBuildInputs = [ asgiref msgpack posix_ipc ];

  meta = with stdenv.lib; {
    description = "Posix IPC-backed ASGI channel layer implementation";
    license = licenses.bsd3;
    homepage = http://github.com/django/asgi_ipc/;
  };
}
