{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update,
  writeShellApplication,

  # build-system
  hatchling,
  uv-dynamic-versioning,

  # dependencies
  anyio,
  genai-prices,
  griffelib,
  httpx2,
  opentelemetry-api,
  pydantic-graph,
  pydantic,
  typing-inspection,

  # optional-dependencies
  anthropic,
  argcomplete,
  boto3,
  botocore,
  cohere,
  ddgs,
  exa-py,
  fastmcp-slim,
  google-genai,
  groq,
  huggingface-hub,
  hf-xet,
  httpx,
  logfire,
  markdownify,
  mistralai,
  openai,
  prefect,
  prompt-toolkit,
  pyperclip,
  pyyaml,
  rich,
  sentence-transformers,
  starlette,
  tenacity,
  temporalio,
  tiktoken,
  uvicorn,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydantic-ai-slim";
  version = "2.54.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-ai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fkE2rww4xoJgeGCF/MP4ijZySTcU411NriIVa7w6NXs=";
  };

  sourceRoot = "${finalAttrs.src.name}/pydantic_ai_slim";

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    anyio
    genai-prices
    griffelib
    httpx2
    opentelemetry-api
    pydantic-graph
    pydantic
    typing-inspection
  ];

  optional-dependencies = {
    ag-ui = [
      # ag-ui-protocol is not packaged yet
      starlette
    ];
    anthropic = [ anthropic ];
    bedrock = [ boto3 ];
    bedrock-mantle = [
      botocore
      openai
    ];
    cerebras = [ openai ];
    cli = [
      argcomplete
      prompt-toolkit
      pyperclip
      pyyaml
      rich
    ];
    cohere = [ cohere ];
    crusoe = [ openai ];
    dbos = [
      # dbos is not packaged yet
    ];
    duckduckgo = [ ddgs ];
    evals = [
      # pydantic-evals is not packaged yet
    ];
    exa = [ exa-py ];
    google = [ google-genai ];
    google-realtime =
      finalAttrs.passthru.optional-dependencies.google
      ++ finalAttrs.passthru.optional-dependencies.realtime;
    groq = [ groq ];
    huggingface = lib.optionals (stdenv.hostPlatform.isx86_64 || stdenv.hostPlatform.isAarch64) [
      # hf-xet is x86_64/aarch64-only upstream
      huggingface-hub
      hf-xet
    ];
    logfire = [ logfire ] ++ logfire.optional-dependencies.httpx;
    mcp = [ fastmcp-slim ] ++ fastmcp-slim.optional-dependencies.client;
    mcp-tasks = [
      # fastmcp-tasks is not packaged yet (requires FastMCP 4)
    ];
    mistral = [ mistralai ];
    openai = [
      openai
      tiktoken
    ];
    openai-realtime =
      finalAttrs.passthru.optional-dependencies.openai
      ++ finalAttrs.passthru.optional-dependencies.realtime;
    openrouter = [ openai ];
    prefect = [ prefect ];
    realtime = [ websockets ];
    retries = [
      httpx
      tenacity
    ];
    sentence-transformers = [ sentence-transformers ];
    snowflake = [ openai ];
    spec = [
      # pydantic-handlebars is not packaged yet
      pyyaml
    ];
    tavily = [
      # tavily-python is not packaged yet
    ];
    temporal = [ temporalio ];
    typesafe = [
      # typesafe-sdk is not packaged yet
    ];
    ui = [ starlette ];
    voyageai = [
      # voyageai is not packaged yet
    ];
    web = [
      starlette
      uvicorn
    ];
    web-fetch = [ markdownify ];
    xai = [
      # xai-sdk is not packaged yet
    ];
    xai-realtime =
      finalAttrs.passthru.optional-dependencies.xai
      ++ finalAttrs.passthru.optional-dependencies.openai
      ++ finalAttrs.passthru.optional-dependencies.realtime;
    zai = [ openai ];
  };

  pythonImportsCheck = [
    "pydantic_ai"
  ];

  doCheck = false;

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "pydantic-ai-updater";
    runtimeInputs = [
      nix-update
    ];
    text = ''
      nix-update --build --commit python3Packages.genai-prices
      nix-update --build --commit python3Packages.pydantic-graph
      nix-update --build --commit python3Packages.pydantic-ai-harness
      nix-update --build python3Packages.pydantic-ai-slim
    '';
  });

  meta = {
    changelog = "https://github.com/pydantic/pydantic-ai/releases/tag/${finalAttrs.src.tag}";
    description = "GenAI Agent Framework, the Pydantic way";
    homepage = "https://github.com/pydantic/pydantic-ai/tree/main/pydantic_ai_slim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
