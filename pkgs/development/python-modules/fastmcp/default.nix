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
  fakeredis,
  google-genai,
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
  opentelemetry-sdk,
  psutil,
  pytest-asyncio,
  pytest-examples,
  pytest-httpx,
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
    gemini = [ google-genai ];
    openai = [ openai ];
    tasks = [
      pydocket
      fakeredis
    ]
    ++ fakeredis.optional-dependencies.lua;
  };

  pythonRelaxDeps = [ "py-key-value-aio" ];

  pythonImportsCheck = [ "fastmcp" ];

  # The mcp library spawns subprocess servers with a minimal environment
  # (HOME, LOGNAME, PATH, SHELL, TERM, USER) that excludes PYTHONPATH.
  # This means the subprocess's Python interpreter cannot find fastmcp.
  # Inject PYTHONPATH into the env dicts used by tests that spawn MCP
  # server subprocesses.
  postPatch = ''
    substituteInPlace src/fastmcp/client/transports/stdio.py \
      --replace-fail \
        'self.env = env' \
        'self.env = (env or {}) | {"PYTHONPATH": os.environ.get("PYTHONPATH", "")}'
  '';

  nativeCheckInputs = [
    dirty-equals
    email-validator
    fastapi
    inline-snapshot
    lupa
    opentelemetry-sdk
    psutil
    pytest-asyncio
    pytest-examples
    pytest-httpx
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    # Requires uv binary
    "test_uv_transport"
    "test_uv_transport_module"

    # Requires network access
    "test_github_api_schema_performance"

    # Hang forever
    "test_nested_streamable_http_server_resolves_correctly"

    # 'builtins.BurnerRedis' object has no attribute 'get_next_client_id'
    "test_background_task_can_read_snapshotted_request_headers"
    "test_background_task_current_http_dependencies_restore_headers"
    "test_sync_context_functions_work_in_background_without_deps"

    # Imports from fastmcp.apps.* (prefab-ui) and google_genai are unavailable
    "test_doc_examples_quality"

    # Strict string search for `env={'KEY': 'val'}`, which breaks due
    # to env patching to fix transport tests.
    "test_stdio_transport_with_env"

    # assert 'INFO' == 'DEBUG' — environment-sensitive log-level default
    "test_temporary_settings"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: Server failed to start after 10 attempts
    "test_unauthorized_access"
    "test_stateless_proxy"
  ];

  disabledTestPaths = [
    # Requires prefab-ui (optional dependency)
    "tests/apps"
    "tests/test_apps.py"
    "tests/test_apps_prefab.py"
    "tests/test_fastmcp_app.py"
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
