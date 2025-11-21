{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  anthropic,
  langchain-core,
  pydantic,

  # tests
  blockbuster,
  langchain,
  langchain-tests,
  pytest-asyncio,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-anthropic";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-anthropic==${version}";
    hash = "sha256-dmuDgKQW1yAz/8tjQx7LaUiuz5Sh4cAyd9nt33mCPbI=";
  };

  sourceRoot = "${src.name}/libs/partners/anthropic";

  build-system = [ hatchling ];

  dependencies = [
    anthropic
    langchain-core
    pydantic
  ];

  nativeCheckInputs = [
    blockbuster
    langchain
    langchain-tests
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [
    "tests/unit_tests"
  ];

  disabledTests = [
    # TypeError from Pydantic
    # https://github.com/langchain-ai/langchain/issues/34068
    "test_creates_bash_tool"
    "test_replaces_tool_with_claude_descriptor"
  ];

  pythonImportsCheck = [ "langchain_anthropic" ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-anthropic==";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-anthropic/releases/tag/${src.tag}";
    description = "Build LangChain applications with Anthropic";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/anthropic";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sarahec
    ];
  };
}
