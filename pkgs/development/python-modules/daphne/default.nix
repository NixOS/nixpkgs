{ stdenv, buildPythonPackage, fetchPypi,
  asgiref, autobahn, twisted, hypothesis
}:
buildPythonPackage rec {
  pname = "daphne";
  name = "${pname}-${version}";
  version = "2.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bb2075ce35ca00f2e5440cc034dfebd5c00d346de62ea45f099db089b868c31f";
  };

  buildInputs = [ hypothesis ];
  propagatedBuildInputs = [ asgiref autobahn twisted ];

  meta = with stdenv.lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    license = licenses.bsd3;
    homepage = https://github.com/django/daphne;
  };
}
