{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      url = "https://github.com/pallets-eco/flask-alembic/pull/50/commits/d99f5752be040a4ce34cf1bc20a21f2ed1eb42f7.patch";
      hash = "sha256-JzeRQRrKtCsBhU1N287MNYJfitOZd4PyXCbypAdNyDU=";
    })
  ];

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
    # https://github.com/pallets-eco/flask-alembic/issues/47
    broken = pythonAtLeast "3.13";
    homepage = "https://github.com/pallets-eco/flask-alembic";
    changelog = "https://github.com/pallets-eco/flask-alembic/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ erictapen ];
  };
}
