{ stdenv, buildPythonPackage, fetchPypi,
  asgiref, autobahn, twisted, hypothesis
}:
buildPythonPackage rec {
  pname = "daphne";
  name = "${pname}-${version}";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13jv8jn8nf522smwpqdy4lq6cpd06fcgwvgl67i622rid51fj5gb";
  };

  buildInputs = [ hypothesis ];
  propagatedBuildInputs = [ asgiref autobahn twisted ];

  meta = with stdenv.lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    license = licenses.bsd3;
    homepage = https://github.com/django/daphne;
  };
}
