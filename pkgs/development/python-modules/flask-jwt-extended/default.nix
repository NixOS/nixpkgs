{ lib, buildPythonPackage, fetchPypi, dateutil, flask, pyjwt, werkzeug, pytest }:

buildPythonPackage rec {
  pname = "Flask-JWT-Extended";
  version = "3.25.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bbf4467f41c56cf1fd8a5870d2556f419c572aad2b4085757581c3f9b4d7767a";
  };

  propagatedBuildInputs = [ dateutil flask pyjwt werkzeug ];
  checkInputs = [ pytest ];

  checkPhase = ''
    pytest tests/
  '';

  meta = with lib; {
    description = "JWT extension for Flask";
    homepage = "https://flask-jwt-extended.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
  };
}
