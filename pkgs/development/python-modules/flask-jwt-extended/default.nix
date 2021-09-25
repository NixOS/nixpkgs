{ lib, buildPythonPackage, fetchPypi, python-dateutil, flask, pyjwt, werkzeug, pytest }:

buildPythonPackage rec {
  pname = "Flask-JWT-Extended";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6e2b40d548b9dfc6051740c4552c097ac38e514e500c16c682d9a533d17ca418";
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
