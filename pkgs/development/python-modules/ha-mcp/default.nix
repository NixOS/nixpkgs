{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  anyio,
  authlib,
  bash,
  certifi,
  cryptography,
  cyclopts,
  exceptiongroup,
  gitMinimal,
  griffelib,
  httpx,
  httpx2,
  joserfc,
  jsonref,
  jsonschema,
  jsonschema-path,
  openapi-pydantic,
  opentelemetry-api,
  packaging,
  platformdirs,
  probatio,
  psutil,
  py-key-value-aio,
  pydantic,
  pydantic-monty,
  pydantic-settings,
  pyjwt,
  pyperclip,
  pytest-asyncio,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  python-dotenv,
  python-multipart,
  pyyaml,
  quickjs,
  rich,
  ruamel-yaml,
  sse-starlette,
  starlette,
  testcontainers,
  truststore,
  typing-extensions,
  typing-inspection,
  tzdata,
  uncalled-for,
  uvicorn,
  voluptuous,
  watchfiles,
  websockets,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "ha-mcp";
  version = "9.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "homeassistant-ai";
    repo = "ha-mcp";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-IlJ/wCXITsg0yl9fugeJBozZJ2jTPymWlkRfgqaNeOM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.12.17,<0.14" "uv_build"
  '';

  build-system = [
    uv-build
  ];

  pythonRelaxDeps = true;

  dependencies = [
    anyio
    authlib
    certifi
    cryptography
    cyclopts
    exceptiongroup
    griffelib
    httpx
    httpx2
    joserfc
    jsonref
    jsonschema
    jsonschema-path
    openapi-pydantic
    opentelemetry-api
    packaging
    platformdirs
    psutil
    pydantic
    pydantic-monty
    pydantic-settings
    py-key-value-aio
    pyjwt
    pyperclip
    python-dotenv
    python-multipart
    pyyaml
    rich
    sse-starlette
    starlette
    truststore
    typing-extensions
    typing-inspection
    tzdata
    uncalled-for
    uvicorn
    watchfiles
  ]
  ++ py-key-value-aio.optional-dependencies.filetree
  ++ py-key-value-aio.optional-dependencies.keyring
  ++ py-key-value-aio.optional-dependencies.memory
  ++ httpx.optional-dependencies.socks;

  nativeCheckInputs = [
    bash
    gitMinimal
    httpx
    probatio
    pytest-asyncio
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    quickjs
    ruamel-yaml
    testcontainers
    voluptuous
    websockets
  ];

  pytestFlags = [
    "tests/src/unit/"
  ];

  disabledTestPaths = [
    # requires internet
    "tests/src/unit/test_agent_docs_structure.py::test_tracked_markdown_local_links_resolve"
    "tests/src/unit/test_e2e_boot_knobs.py"
    "tests/src/unit/test_ha_release_inputs.py"
    # Requires Codex
    "tests/src/unit/test_codex_workflow_contracts.py"
    # tests changelog generation
    "tests/src/unit/test_changelog_template.py"
    # Our git repo does not match what upstream wants
    "tests/src/unit/test_duplicate_code_ratchet.py::test_repository_matches_the_baseline"
    "tests/src/unit/test_module_size_ratchet.py::test_repository_matches_the_baseline"
    "tests/src/unit/test_supply_chain_workflow_shape.py"
    # we can trust that pytest-xdist works
    "tests/src/unit/test_doomed_run.py::test_xdist_abort_retains_first_shared_fixture_failure"
    # Don't test home-assistant version requirements
    "tests/src/unit/test_ha_constraint_alignment.py::TestParseRequirementLines::test_parses_names_canonically_and_skips_noise"
    # requires mcp<2
    "tests/src/unit/test_llm_api.py"
    "tests/src/unit/test_llm_tool_metadata.py::TestCoreToolMetadata"
    # requires uv
    "tests/src/unit/test_resources.py::TestWheelContents"
    # hardcodes PATH in tests
    "tests/src/unit/test_mirror_sync_workflow_shape.py"
    # changes PYTHONPATH
    "tests/src/unit/test_locale_parity.py"
    # error is slightly worded differently
    "tests/src/unit/test_oauth_dcr.py::test_register_rejects_deeply_nested_json_body"
    "tests/src/unit/test_webhook_proxy_oauth_unified.py::test_dcr_register_rejects_deeply_nested_json"
    # error count is lightly different
    "tests/src/unit/test_bulk_device_control.py::TestRegisteredBulkToolCompatibility::test_mixed_schema_invalid_rows_are_reported_without_aborting"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version-regex=^v([0-9]+\\.[0-9]+\\.[0-9]+)$"
    ];
  };

  pythonImportsCheck = [ "ha_mcp" ];

  meta = {
    description = "MCP server for controlling Home Assistant via natural language";
    homepage = "https://github.com/homeassistant-ai/ha-mcp";
    changelog = "https://github.com/homeassistant-ai/ha-mcp/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
    mainProgram = "ha-mcp";
  };
})
