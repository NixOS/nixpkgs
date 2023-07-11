{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, alembic
, flask
, flask_script
, flask-sqlalchemy
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "Flask-Migrate";
  version = "4.0.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-x52LGYvXuTUCP9dR3FP7a/xNRWyCAV1sReDAYJbYDvE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
