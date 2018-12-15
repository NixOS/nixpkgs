{ stdenv, buildPythonPackage, fetchPypi, flask, pyjwt, werkzeug, pytest }:

buildPythonPackage rec {
  pname = "Flask-JWT-Extended";
  version = "3.13.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10qz3ljr2kpd93al2km6iijxp23z33kvvwd0y5bc840f86b4mra8";
  };

  propagatedBuildInputs = [ flask pyjwt werkzeug ];
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
