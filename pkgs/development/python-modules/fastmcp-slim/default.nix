{
  lib,
  buildPythonPackage,
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
  pydantic-settings,
  pydocket,
  pyjwt,
  pyperclip,
  python-dotenv,
  python-multipart,
  pyyaml,
  rich,
  typing-extensions,
  uncalled-for,
  uvicorn,
  watchfiles,
  websockets,
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
      httpx
      mcp
      opentelemetry-api
    ];
    openai = [ openai ];
    server = [
      authlib
      cyclopts
      griffelib
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
    tasks = [
      pydocket
    ];
  };

  pythonImportsCheck = [ "fastmcp" ];

  # tests are done in fastmcp package
  doCheck = false;

  meta = {
    description = "Dependency-slim FastMCP package";
    changelog = "https://github.com/jlowin/fastmcp/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/PrefectHQ/fastmcp/tree/main/fastmcp_slim";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
