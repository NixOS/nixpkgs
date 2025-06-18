{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,
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
  version = "3.1.1";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-alembic";
    tag = version;
    hash = "sha256-iHJr9l3w1WwZXDl573IV7+A7RDcawGL20sxxhAQQ628=";
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

  meta = with lib; {
    # https://github.com/pallets-eco/flask-alembic/issues/47
    broken = pythonAtLeast "3.13";
    homepage = "https://github.com/pallets-eco/flask-alembic";
    changelog = "https://github.com/pallets-eco/flask-alembic/blob/${src.tag}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ erictapen ];
  };
}
