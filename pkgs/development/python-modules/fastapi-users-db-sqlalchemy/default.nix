{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-regex-commit,

  # dependencies
  fastapi-users,
  sqlalchemy,

  # tests
  aiosqlite,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastapi-users-db-sqlalchemy";
  version = "7.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastapi-users";
    repo = "fastapi-users-db-sqlalchemy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VP//iYzyflqzCn/SkgeoSN+DjirLBWuH9yDJwtcCXCA=";
  };

  build-system = [
    hatchling
    hatch-regex-commit
  ];

  dependencies = [
    fastapi-users
    sqlalchemy
  ];

  nativeCheckInputs = [
    aiosqlite
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fastapi_users_db_sqlalchemy" ];

  meta = {
    changelog = "https://github.com/fastapi-users/fastapi-users-db-sqlalchemy/releases/tag/${finalAttrs.src.tag}";
    description = "FastAPI Users database adapter for SQLAlchemy";
    homepage = "https://github.com/fastapi-users/fastapi-users-db-sqlalchemy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mulatta ];
  };
})
