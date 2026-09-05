{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fastmcp,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  anthropic,
  authlib,
  azure-identity,
  cyclopts,
  exceptiongroup,
  google-genai,
  griffelib,
  httpx2,
  joserfc,
  jsonref,
  jsonschema-path,
  mcp,
  mcp-types,
  openai,
  openapi-pydantic,
  opentelemetry-api,
  packaging,
  platformdirs,
  py-key-value-aio,
  pydantic,
  pydantic-monty,
  pydantic-settings,
  pyjwt,
  pyperclip,
  python-dotenv,
  python-multipart,
  pyyaml,
  rich,
  starlette,
  typing-extensions,
  uncalled-for,
  uvicorn,
  watchfiles,
  websockets,

  # tests
  anyio,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastmcp-slim";
  inherit (fastmcp) version src;
  sourceRoot = "${finalAttrs.src.name}/fastmcp_slim";
  pyproject = true;

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    mcp-types
    platformdirs
    pydantic
    pydantic-settings
    python-dotenv
    rich
    typing-extensions
  ]
  ++ pydantic.optional-dependencies.email;

  optional-dependencies = {
    anthropic = [ anthropic ];
    apps = [
      # unpackaged prefab-ui
    ];
    azure = [
      azure-identity
      pyjwt
    ];
    client = [
      authlib
    ]
    ++ finalAttrs.passthru.optional-dependencies.mcp
    ++ py-key-value-aio.optional-dependencies.filetree
    ++ py-key-value-aio.optional-dependencies.keyring
    ++ py-key-value-aio.optional-dependencies.memory;
    code-mode = [ pydantic-monty ];
    gemini = [
      google-genai
      jsonref
    ];
    mcp = [
      exceptiongroup
      httpx2
      mcp
      opentelemetry-api
      starlette
    ];
    openai = [ openai ];
    server = [
      authlib
      cyclopts
      griffelib
      joserfc
      jsonref
      jsonschema-path
      openapi-pydantic
      packaging
      py-key-value-aio
      pyperclip
      python-multipart
      pyyaml
      uncalled-for
      uvicorn
      watchfiles
      websockets
    ]
    ++ finalAttrs.passthru.optional-dependencies.mcp
    ++ py-key-value-aio.optional-dependencies.filetree
    ++ py-key-value-aio.optional-dependencies.keyring
    ++ py-key-value-aio.optional-dependencies.memory;
  };

  pythonImportsCheck = [ "fastmcp" ];

  nativeInstallCheckInputs = [
    anyio
    griffelib
    jsonref
    mcp
  ];

  installCheckPhase = ''
    runHook preInstallCheck

    cd "$TMPDIR"
    python - <<'PY'
    from functools import partial

    from fastmcp.tools.function_tool import _resolve_param_hints


    class Item:
        pass


    async def base(prefix: str, items: list[Item]) -> str:
        return prefix


    hints = _resolve_param_hints(partial(base, "bound"))
    assert hints["items"] == list[Item]
    assert "prefix" not in hints
    PY

    runHook postInstallCheck
  '';

  # upstream tests are done in fastmcp package
  doCheck = pythonAtLeast "3.14";

  meta = {
    description = "Dependency-slim FastMCP package";
    changelog = "https://github.com/jlowin/fastmcp/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/PrefectHQ/fastmcp/tree/main/fastmcp_slim";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
