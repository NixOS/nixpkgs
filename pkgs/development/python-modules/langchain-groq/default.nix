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
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-groq==${version}";
    hash = "sha256-WpIP41eALPoWuYjm2ygEH7TwClKYwAG0uEd1ZbbqMTY=";
  };

  sourceRoot = "${src.name}/libs/partners/groq";

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
    # Requires groq api < 1.0.0, but 1.0.0 is backwards compatible
    "groq"
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

  disabledTests = [
    # These tests fail when langchain-core gets ahead of the package
    "test_groq_serialization"
    "test_serdes"
  ];

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
