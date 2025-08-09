{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  langchain-core,
  groq,

  # tests
  langchain-tests,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-groq";
  version = "0.3.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-groq==${version}";
    hash = "sha256-f0s8fBT1+uZbatWSPehKfrGYGotBFeNixCiGaAc753o=";
  };

  sourceRoot = "${src.name}/libs/partners/groq";

  build-system = [ pdm-backend ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  dependencies = [
    langchain-core
    groq
  ];

  nativeCheckInputs = [
    langchain-tests
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_groq" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "langchain-groq==";
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    description = "Integration package connecting Groq and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/groq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      sarahec
    ];
  };
}
