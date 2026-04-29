{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  anthropic,
  authlib,
  azure-identity,
  cyclopts,
  exceptiongroup,
  griffelib,
  httpx,
  jsonref,
  jsonschema-path,
  mcp,
  openai,
  openapi-pydantic,
  opentelemetry-api,
  packaging,
  platformdirs,
  py-key-value-aio,
  pydantic,
  pydantic-monty,
  pydocket,
  pyjwt,
  pyperclip,
  python-dotenv,
  pyyaml,
  rich,
  uncalled-for,
  uvicorn,
  watchfiles,
  websockets,

  # tests
  dirty-equals,
  email-validator,
  fastapi,
  inline-snapshot,
  lupa,
  psutil,
  pytest-asyncio,
  pytest-examples,
  pytest-httpx,
  pytest-retry,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastmcp";
  version = "3.2.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "PrefectHQ";
    repo = "fastmcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rJpxPvqAaa6/vXhG1+R9dI32cY/54e6I+F/zyBVoqBM=";
  };

  # The mcp library spawns subprocess servers with a minimal environment
  # (HOME, LOGNAME, PATH, SHELL, TERM, USER) that excludes PYTHONPATH.
  # This means the subprocess's Python interpreter cannot find fastmcp.
  # Inject PYTHONPATH into the env dicts used by tests that spawn MCP
  # server subprocesses.
  postPatch = ''
    substituteInPlace tests/test_mcp_config.py \
      --replace-fail \
        '"command": "python",' \
        '"command": "python", "env": {"PYTHONPATH": os.environ.get("PYTHONPATH", "")},'
    substituteInPlace tests/client/test_stdio.py \
      --replace-fail \
        'PythonStdioTransport(script_path=' \
        'PythonStdioTransport(env={"PYTHONPATH": os.environ.get("PYTHONPATH", "")}, script_path=' \
      --replace-fail \
        'script_path=stdio_script_with_stderr,' \
        'env={"PYTHONPATH": os.environ.get("PYTHONPATH", "")}, script_path=stdio_script_with_stderr,'
    substituteInPlace tests/server/test_server.py \
      --replace-fail \
        'script_path=server_file' \
        'env={"PYTHONPATH": os.environ.get("PYTHONPATH", "")}, script_path=server_file'
    substituteInPlace tests/cli/test_run.py \
      --replace-fail \
        'import inspect''\nimport json' \
        'import inspect''\nimport json''\nimport os' \
      --replace-fail \
        'StdioMCPServer(command="python", args=[str(script_path)])' \
        'StdioMCPServer(command="python", args=[str(script_path)], env={"PYTHONPATH": os.environ.get("PYTHONPATH", "")})'
  '';

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    authlib
    cyclopts
    exceptiongroup
    griffelib
    httpx
    jsonref
    jsonschema-path
    mcp
    openapi-pydantic
    opentelemetry-api
    packaging
    platformdirs
    py-key-value-aio
    pydantic
    pyperclip
    python-dotenv
    pyyaml
    rich
    uncalled-for
    uvicorn
    watchfiles
    websockets
  ]
  ++ py-key-value-aio.optional-dependencies.filetree
  ++ py-key-value-aio.optional-dependencies.keyring
  ++ py-key-value-aio.optional-dependencies.memory
  ++ pydantic.optional-dependencies.email;

  optional-dependencies = {
    anthropic = [ anthropic ];
    azure = [
      azure-identity
      pyjwt
    ];
    code-mode = [ pydantic-monty ];
    openai = [ openai ];
    tasks = [ pydocket ];
  };

  pythonRelaxDeps = [ "py-key-value-aio" ];

  pythonImportsCheck = [ "fastmcp" ];

  nativeCheckInputs = [
    azure-identity
    dirty-equals
    email-validator
    fastapi
    inline-snapshot
    lupa
    psutil
    pyjwt
    pytest-asyncio
    pytest-examples
    pytest-httpx
    pytest-retry
    pytest-timeout
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies
  ++ inline-snapshot.optional-dependencies.dirty-equals;

  disabledTests = [
    # Requires uv binary
    "test_uv_transport"
    "test_uv_transport_module"

    # Requires network access
    "test_github_api_schema_performance"

    # Hang forever
    "test_nested_streamable_http_server_resolves_correctly"

    # Imports from fastmcp.apps.* (prefab-ui) and google_genai are unavailable
    "test_doc_examples_quality"

    # Requires pydocket >= 0.19.0, but nixpkgs has 0.17.1
    "test_timeout_with_task_mode"

    # assert 'INFO' == 'DEBUG' — environment-sensitive log-level default
    "test_temporary_settings"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: Server failed to start after 10 attempts
    "test_unauthorized_access"

    # Failed: DID NOT RAISE <class 'fastmcp.exceptions.ToolError'>
    "test_stateless_proxy"
  ];

  disabledTestPaths = [
    # These depend on the optional package prefab-ui (https://github.com/PrefectHQ/prefab),
    # which is not yet available in nixpkgs.
    "tests/apps/test_approval.py"
    "tests/apps/test_choice.py"
    "tests/apps/test_file_upload.py"
    "tests/apps/test_form.py"
    "tests/test_apps.py"
    "tests/test_apps_prefab.py"
    "tests/test_fastmcp_app.py"
    # These tests use tasks and require pydocket >=0.19.0, but nixpkgs only has 0.17.1.
    "tests/client/tasks"
    "tests/client/transports/test_memory_transport.py"
    "tests/server/http/test_http_dependencies.py"
    "tests/server/mount/test_advanced.py"
    "tests/server/providers/test_local_provider.py"
    "tests/server/tasks"
    "tests/server/test_dependencies.py"
    "tests/server/test_server_docket.py"
    "tests/server/test_tool_annotations.py"
    "tests/tools/tool/test_tool.py"
    "tests/utilities/test_async_utils.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: Server failed to start after 10 attempts
    "tests/client/auth/test_oauth_client.py"
    "tests/client/test_sse.py"
    "tests/client/test_streamable_http.py"
    "tests/server/auth/test_jwt_provider.py"
    "tests/server/http/test_http_dependencies.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Fast, Pythonic way to build MCP servers and clients";
    changelog = "https://github.com/PrefectHQ/fastmcp/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/PrefectHQ/fastmcp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
      squat
    ];
  };
})
