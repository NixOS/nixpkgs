{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, alembic
, flask
, flask_script
, flask-sqlalchemy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "Flask-Migrate";
  version = "4.0.2";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6P5oIH/mVuMy4J71VIRD1p+qbvPUlq3COpytEgKz1qo=";
  };

  propagatedBuildInputs = [
    alembic
    flask
    flask-sqlalchemy
  ];

  pythonImportsCheck = [
    "flask_migrate"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    flask_script
  ];

  meta = with lib; {
    description = "SQLAlchemy database migrations for Flask applications using Alembic";
    homepage = "https://github.com/miguelgrinberg/Flask-Migrate";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
