{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  alembic,
  flask,
  sqlalchemy,
  pytestCheckHook,
  flask-sqlalchemy,
  flask-sqlalchemy-lite,
}:

buildPythonPackage rec {
  pname = "flask-alembic";
  version = "3.3.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-alembic";
    tag = version;
    hash = "sha256-ljhIUfdkouheKqRW6SCuqiUBN6cGdVrcpaaeRBOUJQk=";
  };

  build-system = [ flit-core ];

  dependencies = [
    alembic
    flask
    sqlalchemy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    flask-sqlalchemy
    flask-sqlalchemy-lite
  ];

  pythonImportsCheck = [ "flask_alembic" ];

  meta = {
    homepage = "https://github.com/pallets-eco/flask-alembic";
    changelog = "https://github.com/pallets-eco/flask-alembic/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
