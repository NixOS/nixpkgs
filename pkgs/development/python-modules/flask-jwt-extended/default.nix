{ stdenv, buildPythonPackage, fetchPypi, dateutil, flask, pyjwt, werkzeug, pytest }:

buildPythonPackage rec {
  pname = "Flask-JWT-Extended";
  version = "3.23.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05nf94dp80i68gs61pf67qj1y6i56jgdxmibqmns5wz6z33fi7wj";
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
