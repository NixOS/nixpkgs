{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  exceptiongroup,
  httpx,
  mcp,
  openapi-pydantic,
  python-dotenv,
  rich,
  typer,
  websockets,

  # tests
  dirty-equals,
  fastapi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fastmcp";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jlowin";
    repo = "fastmcp";
    tag = "v${version}";
    hash = "sha256-F4lgMm/84svLZo6SZ7AubsC73s4tffqjJcd9gvA7hGA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "uv-dynamic-versioning>=0.7.0"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    exceptiongroup
    httpx
    mcp
    openapi-pydantic
    python-dotenv
    rich
    typer
    websockets
  ];

  pythonImportsCheck = [ "fastmcp" ];

  nativeCheckInputs = [
    dirty-equals
    fastapi
    pytestCheckHook
  ];

  meta = {
    description = "The fast, Pythonic way to build MCP servers and clients";
    changelog = "https://github.com/jlowin/fastmcp/releases/tag/v${version}";
    homepage = "https://github.com/jlowin/fastmcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
