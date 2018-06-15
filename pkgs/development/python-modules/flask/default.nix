{ stdenv, buildPythonPackage, fetchPypi
, itsdangerous, click, werkzeug, jinja2, pytest }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  version = "0.12.4";
  pname = "Flask";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2ea22336f6d388b4b242bc3abf8a01244a8aa3e236e7407469ef78c16ba355dd";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ itsdangerous click werkzeug jinja2 ];

  checkPhase = ''
    py.test
  '';

  # Tests require extra dependencies
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://flask.pocoo.org/;
    description = "A microframework based on Werkzeug, Jinja 2, and good intentions";
    license = licenses.bsd3;
  };
}
