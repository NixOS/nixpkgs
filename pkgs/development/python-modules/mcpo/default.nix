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
  pytestCheckHook,
  python-dotenv,
  pythonOlder,
  typer,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "mcpo";
  version = "0.0.15";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "open-webui";
    repo = "mcpo";
    tag = "v${version}";
    hash = "sha256-b9zCeMwZdss/5bR6t7rvNWhVRJ8p3aIDEKwezU+CzB0=";
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
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mcpo" ];

  meta = {
    description = "Simple, secure MCP-to-OpenAPI proxy server";
    homepage = "https://github.com/open-webui/mcpo/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ codgician ];
  };
}
