{ lib, buildPythonPackage, fetchPypi, python-dateutil, flask, pyjwt, werkzeug, pytest }:

buildPythonPackage rec {
  pname = "Flask-JWT-Extended";
  version = "4.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad6977b07c54e51c13b5981afc246868b9901a46715d9b9827898bfd916aae88";
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
