{ lib, buildPythonPackage, fetchPypi, python-dateutil, flask, pyjwt, werkzeug, pytest }:

buildPythonPackage rec {
  pname = "Flask-JWT-Extended";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-P+gVBL3JGtjxy5db0tlexgElHzG94YQRXjn8fm7SPqY=";
  };

  propagatedBuildInputs = [ python-dateutil flask pyjwt werkzeug ];
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
