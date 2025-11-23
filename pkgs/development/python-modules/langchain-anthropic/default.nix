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
  langchain,
  langchain-tests,
  pytest-asyncio,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-anthropic";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-anthropic==${version}";
    hash = "sha256-Fnre5RYJg4X4FlpEaZydrcH146ooau5hse1RgNcV+qc=";
  };

  sourceRoot = "${src.name}/libs/partners/anthropic";

  build-system = [ hatchling ];

  dependencies = [
    anthropic
    langchain-core
    pydantic
  ];

  nativeCheckInputs = [
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

  disabledTestPaths = [
    # TypeError from Pydantic
    # https://github.com/langchain-ai/langchain/issues/34069
    "tests/unit_tests/test_standard.py::TestAnthropicStandard::test_with_structured_output[PersonB] "
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
