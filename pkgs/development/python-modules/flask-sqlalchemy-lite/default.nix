{
  aiosqlite,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  flit-core,
  lib,
  pytestCheckHook,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "flask-sqlalchemy-lite";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-sqlalchemy-lite";
    tag = version;
    hash = "sha256-c7lTxihlW48bj9+pU2uq2V/dQrZCi5kq2gWdFhipQGE=";
  };

  build-system = [ flit-core ];

  dependencies = [
    flask
    sqlalchemy
  ]
  ++ flask.optional-dependencies.async
  ++ sqlalchemy.optional-dependencies.asyncio;

  pythonImportsCheck = [ "flask_sqlalchemy_lite" ];

  nativeCheckInputs = [
    aiosqlite
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/pallets-eco/flask-sqlalchemy-lite/blob/${src.tag}/CHANGES.md";
    description = "Integrate SQLAlchemy with Flask";
    homepage = "https://github.com/pallets-eco/flask-sqlalchemy-lite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
