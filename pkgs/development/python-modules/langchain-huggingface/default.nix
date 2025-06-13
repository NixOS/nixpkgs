{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  huggingface-hub,
  langchain-core,
  sentence-transformers,
  tokenizers,
  transformers,

  # tests
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
  pname = "langchain-huggingface";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-huggingface==${version}";
    hash = "sha256-TqxssbqqjJV+/ynM2wo3C1aCV6wy0DsvdEuiTvVqNa8=";
  };

  sourceRoot = "${src.name}/libs/partners/huggingface";

  build-system = [ pdm-backend ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  dependencies = [
    huggingface-hub
    langchain-core
    sentence-transformers
    tokenizers
    transformers
  ];

  nativeCheckInputs = [
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

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_huggingface" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "langchain-huggingface==";
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    description = "An integration package connecting Huggingface related classes and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/huggingface";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
