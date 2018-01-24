{ stdenv, buildPythonPackage, fetchPypi,
  asgiref, autobahn, twisted, hypothesis
}:
buildPythonPackage rec {
  pname = "daphne";
  name = "${pname}-${version}";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "302725f223853b05688f28c361e050f8db9568b1ce27340c76272c26b49e6d72";
  };

  buildInputs = [ hypothesis ];
  propagatedBuildInputs = [ asgiref autobahn twisted ];

  meta = with stdenv.lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    license = licenses.bsd3;
    homepage = https://github.com/django/daphne;
  };
}
