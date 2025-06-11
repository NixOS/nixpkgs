{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build-system
  pdm-backend,

  # dependencies
  anthropic,
  langchain-core,
  pydantic,

  # tests
  langchain-tests,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "langchain-anthropic";
  version = "0.3.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-anthropic==${version}";
    hash = "sha256-CloIxDPnBnKDUeS4psRvpz8ifK/xR/U62wG+ORHginM=";
  };

  sourceRoot = "${src.name}/libs/partners/anthropic";

  build-system = [ pdm-backend ];

  dependencies = [
    anthropic
    langchain-core
    pydantic
  ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  nativeCheckInputs = [
    langchain-tests
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_anthropic" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "langchain-anthropic==([0-9.]+)"
    ];
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-anthropic/releases/tag/langchain-anthropic==${version}";
    description = "Build LangChain applications with Anthropic";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/anthropic";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.sarahec
    ];
  };
}
