{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  aiohttp,
  async-timeout,
  langchain-core,
  langchain-text-splitters,
  langgraph,
  langsmith,
  numpy,
  pydantic,
  pyyaml,
  requests,
  sqlalchemy,
  tenacity,

  # runtime
  runtimeShell,

  # tests
  blockbuster,
  freezegun,
  httpx,
  lark,
  pandas,
  pytest-asyncio,
  pytest-mock,
  pytest-socket,
  pytestCheckHook,
  requests-mock,
  responses,
  syrupy,
  toml,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain==${version}";
    hash = "sha256-NQra/L7OfnVyFTbGkSDcG30r8W733eAs9abII53wy4g=";
  };

  sourceRoot = "${src.name}/libs/langchain_v1";

  postPatch = ''
    substituteInPlace langchain/agents/middleware/shell_tool.py \
      --replace-fail '"/bin/bash"' '"${runtimeShell}"'
  '';

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
    "numpy"
    "tenacity"
  ];

  dependencies = [
    aiohttp
    langchain-core
    langchain-text-splitters
    langgraph
    langsmith
    numpy
    pydantic
    pyyaml
    requests
    sqlalchemy
    tenacity
  ]
  ++ lib.optional (pythonOlder "3.11") async-timeout;

  optional-dependencies = {
    numpy = [ numpy ];
  };

  nativeCheckInputs = [
    blockbuster
    freezegun
    httpx
    lark
    pandas
    pytest-asyncio
    pytest-mock
    pytest-socket
    pytestCheckHook
    requests-mock
    responses
    syrupy
    toml
  ];

  pytestFlags = [
    "--only-core"
  ];

  enabledTestPaths = [
    # integration_tests require network access, database access and require `OPENAI_API_KEY`, etc.
    "tests/unit_tests"
  ];

  # All pass with sandbox=false
  disabledTests = [
    # Depends on shell's truncation style
    "test_truncation_indicator_present"
    # Depends on the sleep shell command
    "test_timeout_returns_error"
    # Can't see the shell session results when sandboxed
    "test_startup_and_shutdown_commands"
  ];

  disabledTestPaths = [
    # Their configuration tests don't place nicely with nixpkgs
    "tests/unit_tests/test_pytest_config.py"
  ];

  pythonImportsCheck = [ "langchain" ];

  passthru = {
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain==";
    };
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Building applications with LLMs through composability";
    homepage = "https://github.com/langchain-ai/langchain";
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
