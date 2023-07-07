{ lib
, buildPythonPackage
, fetchPypi
, flask
, mock
, pdm-pep517
, pytestCheckHook
, pythonOlder
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "flask-sqlalchemy";
  version = "3.0.3";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "Flask-SQLAlchemy";
    inherit version;
    hash = "sha256-J2QzXzydfr3J7WBEr6+Yqun6UNegdM71Xd4wfslZA+w=";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    flask
    sqlalchemy
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # flaky
    "test_session_scoping_changing"
    # https://github.com/pallets-eco/flask-sqlalchemy/issues/1084
    "test_persist_selectable"
  ];

  pythonImportsCheck = [
    "flask_sqlalchemy"
  ];

  meta = with lib; {
    description = "SQLAlchemy extension for Flask";
    homepage = "http://flask-sqlalchemy.pocoo.org/";
    changelog = "https://github.com/pallets-eco/flask-sqlalchemy/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
