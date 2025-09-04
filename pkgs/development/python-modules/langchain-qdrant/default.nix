{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  langchain-core,
  pytest,
  freezegun,
  pytest-mock,
  syrupy,
  pytest-watch,
  pytest-asyncio,
  requests,
  pytest-socket,
  gitUpdater,
  qdrant-client,
  pydantic,
}:
buildPythonPackage rec {
  pname = "langchain-qdrant";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    rev = "langchain-qdrant==${version}";
    hash = "sha256-Y8KWaQ8c2agVHGnjRs/T2yBDm0zbFV48K2h/aJ9CDEA=";
  };

  sourceRoot = "${src.name}/libs/partners/qdrant";

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
  ];

  dependencies = [
    qdrant-client
    pydantic
    langchain-core
  ];

  nativeCheckInputs = [
    pytest
    freezegun
    pytest-mock
    syrupy
    pytest-watch
    pytest-asyncio
    requests
    pytest-socket
    langchain-core
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_qdrant" ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "langchain-qdrant==";
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.rev}";
    description = "Integration package connecting Qdrant related classes and LangChain";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/partners/qdrant";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gurjaka
    ];
  };
}
