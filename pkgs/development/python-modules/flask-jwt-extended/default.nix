{ stdenv, buildPythonPackage, fetchPypi, dateutil, flask, pyjwt, werkzeug, pytest }:

buildPythonPackage rec {
  pname = "Flask-JWT-Extended";
  version = "3.24.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p8rwcsscyjw2m7dbybiaflqk4z1r2d1kp9r9qqyjfzblxpyxa0a";
  };

  propagatedBuildInputs = [ dateutil flask pyjwt werkzeug ];
  checkInputs = [ pytest ];

  checkPhase = ''
    pytest tests/
  '';

  meta = with stdenv.lib; {
    description = "JWT extension for Flask";
    homepage = "https://flask-jwt-extended.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
  };
}
