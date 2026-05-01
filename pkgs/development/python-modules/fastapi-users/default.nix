{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-regex-commit,

  # dependencies
  email-validator,
  fastapi,
  makefun,
  pyjwt,
  pwdlib,
  python-multipart,

  # optional-dependencies
  fastapi-users-db-sqlalchemy,
  httpx-oauth,
  redis,

  # tests
  asgi-lifespan,
  cryptography,
  httpx,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastapi-users";
  version = "15.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastapi-users";
    repo = "fastapi-users";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Lx7heqwLt7S8CIY5eG6R/76NuhUtbU6yicEnLhuu0Q=";
  };

  build-system = [
    hatchling
    hatch-regex-commit
  ];

  pythonRelaxDeps = [ "python-multipart" ];

  dependencies = [
    email-validator
    fastapi
    makefun
    pyjwt
    pwdlib
    python-multipart
  ];

  optional-dependencies = {
    oauth = [ httpx-oauth ];
    redis = [ redis ];
    sqlalchemy = [ fastapi-users-db-sqlalchemy ];
  };

  nativeCheckInputs = [
    asgi-lifespan
    cryptography
    httpx
    httpx-oauth
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Require database backends (sqlalchemy, beanie)
    "tests/test_router_users.py"
    "tests/test_router_auth.py"
    "tests/test_router_register.py"
    "tests/test_router_reset.py"
    "tests/test_router_verify.py"
    "tests/test_router_oauth.py"
    # Requires redis
    "tests/test_authentication_strategy_redis.py"
  ];

  pythonImportsCheck = [ "fastapi_users" ];

  meta = {
    changelog = "https://github.com/fastapi-users/fastapi-users/releases/tag/${finalAttrs.src.tag}";
    description = "Ready-to-use and customizable users management for FastAPI";
    homepage = "https://github.com/fastapi-users/fastapi-users";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mulatta ];
  };
})
