{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  cryptography,
  fastapi,
  httpx,
  pyjwt,

  # nativeCheckInputs
  asgi-lifespan,
  openapi-spec-validator,
  pytestCheckHook,
  pytest-asyncio,
  pytest-freezer,
  pytest-mock,
  pytest-socket,
  pydantic-settings,
  respx,
  uvicorn,
}:
buildPythonPackage rec {
  pname = "fastapi-azure-auth";
  version = "5.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "intility";
    repo = "fastapi-azure-auth";
    tag = version;
    hash = "sha256-UHHYrorEUp18QQKOLg0k9o5jaRdkEchBAaOR6D7a/TU=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    cryptography
    fastapi
    httpx
    pyjwt
  ];

  pythonImportsCheck = [
    "fastapi_azure_auth"
  ];

  nativeCheckInputs = [
    asgi-lifespan
    openapi-spec-validator
    pytestCheckHook
    pydantic-settings
    pytest-asyncio
    pytest-freezer
    pytest-mock
    pytest-socket
    respx
    uvicorn
  ];

  # export all vars from the test env file
  preCheck = ''
    set -o allexport
    source $src/tests/.env.test
    set +o allexport
  '';

  disabledTests = [
    # rely on old httpx interfaces
    "test_openapi_schema"
    "test_http_error_old_config_found[asyncio]"
    "test_http_error_old_config_found[trio]"
  ];

  disabledTestPaths = [
    # rely on old httpx interfaces
    "tests/multi_tenant/test_multi_tenant.py"
    "tests/multi_tenant_b2c/test_multi_tenant.py"
    "tests/single_tenant/test_single_tenant.py"
  ];

  meta = {
    description = "FastAPI compatible middleware to authenticate using Azure Entra ID";
    homepage = "https://github.com/intility/fastapi-azure-auth";
    changelog = "https://github.com/intility/fastapi-azure-auth/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ parthiv-krishna ];
  };
}
