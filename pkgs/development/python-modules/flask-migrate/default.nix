{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, alembic
, flask
, flask-script
, flask-sqlalchemy
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "flask-migrate";
  version = "4.0.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-Migrate";
    rev = "refs/tags/v${version}";
    hash = "sha256-fdnoX7ypTpH2mQ+7Xuhzdh706Of7PIVhHQGVbe0jv1s=";
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
    flask-script
  ];

  meta = with lib; {
    description = "SQLAlchemy database migrations for Flask applications using Alembic";
    homepage = "https://github.com/miguelgrinberg/Flask-Migrate";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
