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
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-sqlalchemy-lite";
    rev = "refs/tags/${version}";
    hash = "sha256-LpdPp5Gp74DSJqD1DJqwNeaMKdN5pEAUkxnKGYZcVis=";
  };

  build-system = [ flit-core ];

  dependencies =
    [
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
    changelog = "https://github.com/pallets-eco/flask-sqlalchemy-lite/blob/${src.rev}/CHANGES.md";
    description = "Integrate SQLAlchemy with Flask";
    homepage = "https://github.com/pallets-eco/flask-sqlalchemy-lite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
