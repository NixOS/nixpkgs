{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,

  # build-system
  hatchling,

  # dependencies
  authlib,
  exceptiongroup,
  httpx,
  mcp,
  openapi-pydantic,
  python-dotenv,
  rich,
  typer,

  # tests
  dirty-equals,
  fastapi,
  pytest-httpx,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fastmcp";
  version = "2.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jlowin";
    repo = "fastmcp";
    tag = "v${version}";
    hash = "sha256-FleJkqdUIhGsV+DVYv/Nf5IORntH/aFq9abKn2r/6Is=";
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
    authlib
    exceptiongroup
    httpx
    mcp
    openapi-pydantic
    python-dotenv
    rich
    typer
  ];

  pythonImportsCheck = [ "fastmcp" ];

  nativeCheckInputs = [
    dirty-equals
    fastapi
    pytest-httpx
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # AssertionError: assert 'INFO' == 'DEBUG'
    "test_temporary_settings"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: Server failed to start after 10 attempts
    "tests/auth/providers/test_bearer.py"
    "tests/auth/test_oauth_client.py"
    "tests/client/test_openapi.py"
    "tests/client/test_sse.py"
    "tests/client/test_streamable_http.py"
    "tests/server/http/test_http_dependencies.py"
    "tests/server/http/test_http_dependencies.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "The fast, Pythonic way to build MCP servers and clients";
    changelog = "https://github.com/jlowin/fastmcp/releases/tag/v${version}";
    homepage = "https://github.com/jlowin/fastmcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
