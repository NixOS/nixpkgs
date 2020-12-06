{ stdenv, buildPythonPackage, fetchPypi, flask, mock, sqlalchemy, pytest }:

buildPythonPackage rec {
  pname = "Flask-SQLAlchemy";
  version = "2.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rgsj49gnx361hnb3vn6c1h17497qh22yc3r70l1r6w0mw71bixz";
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
