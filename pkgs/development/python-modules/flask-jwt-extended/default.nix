{ stdenv, buildPythonPackage, fetchPypi, flask, pyjwt, werkzeug, pytest }:

buildPythonPackage rec {
  pname = "Flask-JWT-Extended";
  version = "3.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97c66f197b4b175173bf955b9a845d03d62e521e512e88f6abff707e6859e7c3";
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
