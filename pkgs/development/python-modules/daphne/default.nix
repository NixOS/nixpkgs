{ stdenv, buildPythonPackage, fetchurl,
  asgiref, autobahn, twisted
}:
buildPythonPackage rec {
  name = "daphne-${version}";
  version = "1.0.3";

  src = fetchurl {
    url = "mirror://pypi/d/daphne/${name}.tar.gz";
    sha256 = "1bpavq3sxr66mqwnnfg67pcchyaq7siqyin2r89aqadf6nab58d2";
  };

  propagatedBuildInputs = [ asgiref autobahn twisted ];

  meta = with stdenv.lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    license = licenses.bsd3;
    homepage = https://github.com/django/daphne;
  };
}
