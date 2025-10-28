{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

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
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-groq==${version}";
    hash = "sha256-OuZEdpPp0mKSejd43RW3bXzCzp3E4Pce7flsSr5JleY=";
  };

  sourceRoot = "${src.name}/libs/partners/groq";

  build-system = [ hatchling ];

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

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-groq==";
    };
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
