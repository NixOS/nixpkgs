{ stdenv, buildPythonPackage, fetchPypi, flask, mock, sqlalchemy, pytest }:

buildPythonPackage rec {
  pname = "Flask-SQLAlchemy";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nnllf0ddbh9jlhngnyjj98lbxgxr1csaplllx0caw98syq0k5hc";
  };

  propagatedBuildInputs = [ flask sqlalchemy ];
  checkInputs = [ mock pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "SQLAlchemy extension for Flask";
    homepage = http://flask-sqlalchemy.pocoo.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
