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
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FhmfWz3ftp4N8vUq5Mdq7b/sgjRiNJ2rshobLgorZek=";
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
