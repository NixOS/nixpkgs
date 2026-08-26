{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  anyio,
  httpx2,
  jsonschema,
  mcp-types,
  opentelemetry-api,
  pydantic,
  pyjwt,
  python-multipart,
  sse-starlette,
  starlette,
  typing-extensions,
  typing-inspection,
  uvicorn,

  # optional-dependencies
  # cli
  python-dotenv,
  typer,
  # rich
  rich,

  # tests
  coverage,
  dirty-equals,
  griffelib,
  inline-snapshot,
  logfire,
  pytest-asyncio,
  pytest-examples,
  pytest-xdist,
  pytestCheckHook,
  pyyaml,
  requests,
  trio,
  zensical,
}:

buildPythonPackage (finalAttrs: {
  pname = "mcp";
  version = "2.1.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "modelcontextprotocol";
    repo = "python-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v3qS18hgOxLjm+IEa/knkfyh0Cz2QFtyqxXTZJepevU=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    anyio
    httpx2
    jsonschema
    mcp-types
    opentelemetry-api
    pydantic
    pyjwt
    python-multipart
    sse-starlette
    starlette
    typing-extensions
    typing-inspection
    uvicorn
  ];

  optional-dependencies = {
    cli = [
      python-dotenv
      typer
    ];
    rich = [
      rich
    ];
  };

  pythonImportsCheck = [ "mcp" ];

  nativeCheckInputs = [
    coverage
    dirty-equals
    griffelib
    inline-snapshot
    logfire
    (buildPythonPackage {
      pname = "mcp-example-stories";
      version = "0.0.0";
      src = finalAttrs.src;
      sourceRoot = "${finalAttrs.src.name}/examples";
      pyproject = true;
      build-system = [ hatchling ];
      pythonRemoveDeps = [ "mcp" ];
    })
    pytest-asyncio
    pytest-examples
    pytest-xdist
    pytestCheckHook
    pyyaml
    requests
    trio
    zensical
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  # The stdio transport starts servers as subprocesses,
  # with only a subset (allowlist) of environment variables.
  # It doesn't include PYTHONPATH, so tests that spawn a child interpreter can't import mcp.
  # In upstream CI uv sync installs mcp into the venv's site-packages.
  # But it does include HOME,
  # and every Python process adds $HOME's user site directory to sys.path.
  # So we write the PYTHONPATH to a .pth file there and child interpreters will import mcp again.
  preCheck = ''
    export HOME="$(mktemp -d)"
    local site="$HOME/.local/lib/${python.libPrefix}/site-packages"
    mkdir -p "$site"
    tr ':' '\n' <<< "$PYTHONPATH" > "$site/nix-test-env.pth"
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/modelcontextprotocol/python-sdk/releases/tag/${finalAttrs.src.tag}";
    description = "Official Python SDK for Model Context Protocol servers and clients";
    homepage = "https://github.com/modelcontextprotocol/python-sdk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bryanhonof
      josh
      daniel-fahey
    ];
  };
})
