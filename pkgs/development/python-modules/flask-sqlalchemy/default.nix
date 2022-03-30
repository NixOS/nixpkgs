{ lib, buildPythonPackage, fetchPypi, flask, mock, sqlalchemy, pytestCheckHook }:

buildPythonPackage rec {
  pname = "flask-sqlalchemy";
  version = "2.5.1";

  src = fetchPypi {
  pname = "Flask-SQLAlchemy";
    inherit version;
    sha256 = "2bda44b43e7cacb15d4e05ff3cc1f8bc97936cc464623424102bfc2c35e95912";
  };

  propagatedBuildInputs = [ flask sqlalchemy ];
  checkInputs = [ mock pytestCheckHook ];

  meta = with lib; {
    description = "SQLAlchemy extension for Flask";
    homepage = "https://flask-sqlalchemy.palletsprojects.com/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
