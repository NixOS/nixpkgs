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
  version = "4.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-Migrate";
    tag = "v${version}";
    hash = "sha256-7xQu0Y6aM9WWuH2ImuaopbBS2jE9pVChekVp7SEMHCc=";
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

  meta = with lib; {
    description = "SQLAlchemy database migrations for Flask applications using Alembic";
    homepage = "https://github.com/miguelgrinberg/Flask-Migrate";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
