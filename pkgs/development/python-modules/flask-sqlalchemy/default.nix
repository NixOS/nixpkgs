{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, mock
, flit-core
, pytestCheckHook
, pythonOlder
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "flask-sqlalchemy";
  version = "3.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-sqlalchemy";
    rev = "refs/tags/${version}";
    hash = "sha256-KsQalqv6oY0+f6TazjzEOLrNjhNQKDYLy1uhBWaRzzg=";
  };

  nativeBuildInputs = [
    flit-core
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
