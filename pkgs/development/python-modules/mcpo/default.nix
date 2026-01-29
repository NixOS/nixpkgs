{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  hatchling,

  # dependencies
  click,
  fastapi,
  mcp,
  passlib,
  pydantic,
  pydantic-core,
  pydantic-settings,
  pyjwt,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  pythonOlder,
  typer,
  uvicorn,
  watchdog,
}:

buildPythonPackage rec {
  pname = "mcpo";
  version = "0.0.18";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "open-webui";
    repo = "mcpo";
    tag = "v${version}";
    hash = "sha256-wTLQx6ws2inpmV+o7uFmjLzRKaipM6DZy+QxumzvSkw=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    click
    fastapi
    mcp
    passlib
    pydantic
    pydantic-core
    pydantic-settings
    pyjwt
    python-dotenv
    typer
    uvicorn
    watchdog
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Tests failing in sandbox
    "test_reload_config_handler"
    "test_validate_server_config_disabled_tools_invalid"
  ];

  pythonImportsCheck = [ "mcpo" ];

  meta = {
    description = "Simple, secure MCP-to-OpenAPI proxy server";
    homepage = "https://github.com/open-webui/mcpo/";
    license = lib.licenses.mit;
    mainProgram = "mcpo";
    maintainers = with lib.maintainers; [ codgician ];
  };
}
