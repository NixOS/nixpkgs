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
  cyclopts,
  exceptiongroup,
  httpx,
  mcp,
  openapi-pydantic,
  pydantic,
  pyperclip,
  python-dotenv,
  rich,

  # tests
  dirty-equals,
  email-validator,
  fastapi,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fastmcp";
  version = "2.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jlowin";
    repo = "fastmcp";
    tag = "v${version}";
    hash = "sha256-Y71AJdWcRBDbq63p+lcQplqutz2UTQ3f+pTyhcolpuw=";
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
    cyclopts
    exceptiongroup
    httpx
    mcp
    openapi-pydantic
    pyperclip
    python-dotenv
    rich
  ];

  pythonImportsCheck = [ "fastmcp" ];

  nativeCheckInputs = [
    dirty-equals
    email-validator
    fastapi
    pydantic
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ pydantic.optional-dependencies.email;

  disabledTests = [
    # AssertionError: assert 'INFO' == 'DEBUG'
    "test_temporary_settings"

    # RuntimeError: Client failed to connect: Connection close
    "test_keep_alive_maintains_session_across_multiple_calls"
    "test_keep_alive_false_starts_new_session_across_multiple_calls"
    "test_keep_alive_starts_new_session_if_manually_closed"
    "test_keep_alive_maintains_session_if_reentered"
    "test_close_session_and_try_to_use_client_raises_error"

    # RuntimeError: Client failed to connect: Timed out while waiting for response
    "test_timeout"
    "test_timeout_tool_call_overrides_client_timeout_even_if_lower"

    # assert 0 == 2
    "test_multi_client"

    # fastmcp.exceptions.ToolError: Unknown tool
    "test_multi_client_with_logging"
    "test_multi_client_with_elicitation"
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
    description = "Fast, Pythonic way to build MCP servers and clients";
    changelog = "https://github.com/jlowin/fastmcp/releases/tag/${src.tag}";
    homepage = "https://github.com/jlowin/fastmcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
