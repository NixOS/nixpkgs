{ stdenv, buildPythonPackage, fetchPypi, dateutil, flask, pyjwt, werkzeug, pytest }:

buildPythonPackage rec {
  pname = "Flask-JWT-Extended";
  version = "3.24.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1znqjp780nrp94hjcrcx0945izzl3zsrqkmdac44d2fmlnbdp2by";
  };

  propagatedBuildInputs = [ dateutil flask pyjwt werkzeug ];
  checkInputs = [ pytest ];

  checkPhase = ''
    pytest tests/
  '';

  meta = with stdenv.lib; {
    description = "JWT extension for Flask";
    homepage = https://flask-jwt-extended.readthedocs.io/;
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli ];
  };
}
