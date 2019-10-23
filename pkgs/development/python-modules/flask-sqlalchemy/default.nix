{ stdenv, buildPythonPackage, fetchPypi, flask, mock, sqlalchemy, pytest }:

buildPythonPackage rec {
  pname = "Flask-SQLAlchemy";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6974785d913666587949f7c2946f7001e4fa2cb2d19f4e69ead02e4b8f50b33d";
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
