{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  poetry-core,

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
}:

buildPythonPackage rec {
  pname = "langchain-huggingface";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-huggingface==${version}";
    hash = "sha256-ACR+JzKcnYXROGOQe6DlZeqcYd40KlesgXSUOybOT20=";
  };

  sourceRoot = "${src.name}/libs/partners/huggingface";

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individul components.
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

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^langchain-huggingface==([0-9.]+)$"
    ];
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/langchain-huggingface==${version}";
    description = "An integration package connecting Huggingface related classes and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/huggingface";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
