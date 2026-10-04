{
  atlassian-python-api,
  beautifulsoup4,
  buildPythonPackage,
  cachetools,
  click,
  fakeredis,
  fastmcp,
  fetchFromGitHub,
  hatchling,
  httpx,
  keyring,
  lib,
  markdown,
  markdown-to-confluence,
  markdownify,
  mcp,
  pydantic,
  pypac,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
  python-dotenv,
  requests,
  starlette,
  thefuzz,
  trio,
  truststore,
  types-python-dateutil,
  tzdata,
  unidecode,
  urllib3,
  uv-dynamic-versioning,
  uvicorn,
  versionCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mcp-atlassian";
  version = "0.23.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sooperset";
    repo = "mcp-atlassian";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zbBsEBEfSvsS7dTbbvx2HG2GQhxGtvwVpYf4JPZVCKw=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    atlassian-python-api
    beautifulsoup4
    cachetools
    click
    fakeredis
    fastmcp
    httpx
    keyring
    markdown
    markdown-to-confluence
    markdownify
    mcp
    pydantic
    python-dateutil
    python-dotenv
    requests
    starlette
    thefuzz
    trio
    truststore
    types-python-dateutil
    tzdata
    unidecode
    urllib3
    uvicorn
  ];

  pythonRelaxDeps = [ "fakeredis" ];

  # types-cachetools is obsolete for cachetools >=7.1.
  pythonRemoveDeps = [ "types-cachetools" ];

  nativeCheckInputs = [
    pypac
    pytest-asyncio
    pytestCheckHook
    versionCheckHook
  ];

  enabledTestPaths = [ "tests/unit" ];

  preCheck = ''
    export HOME="$TMPDIR"
  '';

  disabledTestPaths = [
    # This invokes uv to manage a separate development environment.
    "tests/unit/test_stdio_lifecycle.py"
  ];

  pythonImportsCheck = [ "mcp_atlassian" ];

  meta = {
    description = "MCP server for Atlassian products";
    homepage = "https://github.com/sooperset/mcp-atlassian";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ attila ];
    mainProgram = "mcp-atlassian";
  };
})
