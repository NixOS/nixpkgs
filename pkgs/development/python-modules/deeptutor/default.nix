{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  # Build system
  setuptools,
  # Dependencies
  pyyaml,
  jinja2,
  openai,
  tiktoken,
  aiohttp,
  httpx,
  requests,
  ddgs,
  nest-asyncio,
  tenacity,
  pydantic,
  pydantic-settings,
  aiosqlite,
  typer,
  rich,
  prompt-toolkit,
  pyte,
  anthropic,
  dashscope,
  perplexityai,
  oauth-cli-kit,
  llama-index,
  llama-index-retrievers-bm25,
  pymupdf,
  numpy,
  arxiv,
  python-docx,
  openpyxl,
  python-pptx,
  pypdf,
  pdfplumber,
  reportlab,
  defusedxml,
  fastapi,
  uvicorn,
  websockets,
  python-multipart,
  bcrypt,
  python-jose,
  pocketbase,
  loguru,
  json-repair,
  # Optional dependencies
  mcp,
  python-telegram-bot,
  wecom-aibot-sdk,
  lark-oapi,
  dingtalk-stream,
  slack-sdk,
  slackify-markdown,
  qq-botpy,
  python-socketio,
  msgpack,
  python-socks,
  socksio,
  websocket-client,
  zulip,
  pyjwt,
  qrcode,
  # Tests
  git,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "deeptutor";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "HKUDS";
    repo = "DeepTutor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7LwXsYAKTIj7jvuF5t0dzplVu8Ww+rh92cMJyFHHHrM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    jinja2
    openai
    tiktoken
    aiohttp
    httpx
    requests
    ddgs
    nest-asyncio
    tenacity
    pydantic
    pydantic-settings
    aiosqlite
    typer
    rich
    prompt-toolkit
    pyte
    anthropic
    dashscope
    perplexityai
    oauth-cli-kit
    llama-index
    llama-index-retrievers-bm25
    pymupdf
    numpy
    arxiv
    python-docx
    openpyxl
    python-pptx
    pypdf
    pdfplumber
    reportlab
    defusedxml
    fastapi
    uvicorn
    websockets
    python-multipart
    bcrypt
    python-jose
    pocketbase
    loguru
    json-repair
  ]
  ++ python-jose.optional-dependencies.cryptography;

  optional-dependencies = {
    partners = [
      mcp
      python-telegram-bot
      wecom-aibot-sdk
      lark-oapi
      dingtalk-stream
      slack-sdk
      slackify-markdown
      qq-botpy
      python-socketio
      msgpack
      python-socks
      socksio
      websocket-client
      zulip
      pyjwt
      qrcode
    ]
    ++ python-telegram-bot.optional-dependencies.socks
    ++ pyjwt.optional-dependencies.crypto;
  };
  pythonRelaxDeps = [
    "json-repair"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    git
  ]
  ++ finalAttrs.passthru.optional-dependencies.partners;
  pytestFlags = [
    "--import-mode=importlib"
  ];
  pythonImportsCheck = [ "deeptutor" ];
  enabledTestPaths = [
    "tests"
  ];
  disabledTestPaths = [
    "tests/scripts/test_cli_kit.py" # Missing _cli_kit.py file
    "tests/services/rag/test_llamaindex_storage_layout.py" # KeyError: 'storage_path
    "tests/services/config/test_chat_params_config.py" # Strict params requrements
    "tests/services/search/test_web_search_runtime.py" # Regex error
    "tests/services/test_prompt_manager.py" # Importing prompt fails becouse of wrong naming
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Agent-native, Open-sourced Personalized Tutoring";
    mainProgram = "deeptutor";
    homepage = "https://github.com/HKUDS/DeepTutor";
    changelog = "https://github.com/HKUDS/DeepTutor/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      LodWKobku
    ];
  };
})
