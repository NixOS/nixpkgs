{ lib
, buildPythonPackage
, fetchPypi
, flask
, mock
, sqlalchemy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Flask-SQLAlchemy";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2bda44b43e7cacb15d4e05ff3cc1f8bc97936cc464623424102bfc2c35e95912";
  };

  propagatedBuildInputs = [
    flask
    sqlalchemy
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # flaky
    "test_session_scoping_changing"
    # https://github.com/pallets-eco/flask-sqlalchemy/issues/1084
    "test_persist_selectable"
  ];

  meta = with lib; {
    description = "SQLAlchemy extension for Flask";
    homepage = "http://flask-sqlalchemy.pocoo.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
