{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  alembic,
  flask,
  flask-script,
  flask-sqlalchemy,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "flask-migrate";
  version = "4.0.7";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-Migrate";
    tag = "v${version}";
    hash = "sha256-TnihrZ+JQ1XCBlFp6k8lrNpZr4P2/Z6AmFwWZbabz+8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    alembic
    flask
    flask-sqlalchemy
  ];

  pythonImportsCheck = [ "flask_migrate" ];

  nativeCheckInputs = [
    pytestCheckHook
    flask-script
  ];

  meta = {
    description = "SQLAlchemy database migrations for Flask applications using Alembic";
    homepage = "https://github.com/miguelgrinberg/Flask-Migrate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
  };
}
