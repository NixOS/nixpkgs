{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  langchain-core,
  langchain-community,

  # testing
  langchain-tests,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-experimental";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-experimental";
    tag = "libs/experimental/v${version}";
    hash = "sha256-A5qCTOCmKt/a1DTKVOC/WwuLCqOYI5pGhAGo/Y4C/FY=";
  };

  sourceRoot = "${src.name}/libs/experimental";

  patches = [
    # Remove it when https://github.com/langchain-ai/langchain-experimental/pull/58 is merged and released
    ./001-avoid-check-fullpath.patch
  ];

  build-system = [
    pdm-backend
  ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
    "langchain-community"
  ];

  dependencies = [
    langchain-core
    langchain-community
  ];

  nativeCheckInputs = [
    langchain-tests
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_experimental" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "libs/experimental/v";
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain-experimental/releases/tag/${src.tag}";
    description = "Experimental features for LangChain";
    homepage = "https://github.com/langchain-ai/langchain-experimental/tree/main/libs/experimental";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mrdev023
      sarahec
    ];
  };
}
