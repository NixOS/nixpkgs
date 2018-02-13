{ stdenv, buildPythonPackage, fetchPypi,
  asgiref, autobahn, twisted, hypothesis
}:
buildPythonPackage rec {
  pname = "daphne";
  name = "${pname}-${version}";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ecd43a2dd889fb74e16bf8b7f67c076c4ec1b36229ce782272e46c50d56174dd";
  };

  buildInputs = [ hypothesis ];
  propagatedBuildInputs = [ asgiref autobahn twisted ];

  meta = with stdenv.lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    license = licenses.bsd3;
    homepage = https://github.com/django/daphne;
  };
}
