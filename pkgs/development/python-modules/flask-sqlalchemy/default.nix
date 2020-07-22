{ stdenv, buildPythonPackage, fetchPypi, flask, mock, sqlalchemy, pytest }:

buildPythonPackage rec {
  pname = "Flask-SQLAlchemy";
  version = "2.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0b656fbf87c5f24109d859bafa791d29751fabbda2302b606881ae5485b557a5";
  };

  propagatedBuildInputs = [ flask sqlalchemy ];
  checkInputs = [ mock pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with stdenv.lib; {
    description = "SQLAlchemy extension for Flask";
    homepage = "http://flask-sqlalchemy.pocoo.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
