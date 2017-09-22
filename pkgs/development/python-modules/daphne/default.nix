{ stdenv, buildPythonPackage, fetchPypi,
  asgiref, autobahn, twisted, hypothesis
}:
buildPythonPackage rec {
  pname = "daphne";
  name = "${pname}-${version}";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xmmjp21m1w88ljsgnkf6cbzw5nxamh9cfmfgzxffpn4cdmvn96i";
  };

  buildInputs = [ hypothesis ];
  propagatedBuildInputs = [ asgiref autobahn twisted ];

  meta = with stdenv.lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    license = licenses.bsd3;
    homepage = https://github.com/django/daphne;
  };
}
