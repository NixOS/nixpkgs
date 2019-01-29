{ stdenv, buildPythonPackage, fetchPypi, flask, sqlalchemy, pytest }:

buildPythonPackage rec {
  pname = "Flask-SQLAlchemy";
  version = "2.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lvfynbk9y0whpkhqz7kf3hk342sfa3lwqyv25gnb22q5f2vjwar";
  };

  propagatedBuildInputs = [ flask sqlalchemy ];
  checkInputs = [ pytest ];

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
