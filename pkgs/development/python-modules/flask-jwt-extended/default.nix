{ lib, buildPythonPackage, fetchPypi, dateutil, flask, pyjwt, werkzeug, pytest }:

buildPythonPackage rec {
  pname = "Flask-JWT-Extended";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "77ca23f23e80480ea42b9c1d9b0fca214e08db7192583e782c2421416b4a4655";
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
