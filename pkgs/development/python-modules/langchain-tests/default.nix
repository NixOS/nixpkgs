{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  httpx,
  langchain-core,
  syrupy,
  pytest-benchmark,
  pytest-codspeed,
  pytest-recording,
  vcrpy,

  # buildInputs
  pytest,

  # tests
  numpy,
  pytest-asyncio_0,
  pytest-socket,
  pytestCheckHook,

  # passthru
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "langchain-tests";
  version = "0.3.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-tests==${version}";
    hash = "sha256-CufnUFhYTENuq4/32u0w3UZb7TdZxEpshyQqLH6NEZo=";
  };

  sourceRoot = "${src.name}/libs/standard-tests";

  build-system = [ pdm-backend ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individual components.
    "langchain-core"
    "numpy"
    "syrupy"
  ];

  dependencies = [
    httpx
    langchain-core
    pytest-asyncio_0
    pytest-benchmark
    pytest-codspeed
    pytest-recording
    pytest-socket
    syrupy
    vcrpy
  ];

  buildInputs = [ pytest ];

  pythonImportsCheck = [ "langchain_tests" ];

  nativeBuildInputs = [
    numpy
    pytestCheckHook
  ];

  passthru = {
    # python updater script sets the wrong tag
    skipBulkUpdate = true;
    updateScript = gitUpdater {
      rev-prefix = "langchain-tests==";
    };
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langchain/releases/tag/${src.tag}";
    description = "Build context-aware reasoning applications";
    homepage = "https://github.com/langchain-ai/langchain";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
