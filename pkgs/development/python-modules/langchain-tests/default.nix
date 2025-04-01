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

  # buildInputs
  pytest,

  # tests
  numpy,
  pytest-asyncio,
  pytest-socket,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "langchain-tests";
  version = "0.3.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-tests==${version}";
    hash = "sha256-jhdCpZsRvCxDIfaZpdqAdx+rxJTU6QHDgNKc4w7XmR8=";
  };

  sourceRoot = "${src.name}/libs/standard-tests";

  build-system = [ pdm-backend ];

  pythonRelaxDeps = [
    # Each component release requests the exact latest core.
    # That prevents us from updating individul components.
    "langchain-core"
    "numpy"
  ];

  dependencies = [
    httpx
    langchain-core
    pytest-asyncio
    pytest-socket
    syrupy
  ];

  buildInputs = [ pytest ];

  pythonImportsCheck = [ "langchain_tests" ];

  nativeBuildInputs = [
    numpy
    pytestCheckHook
  ];

  passthru = {
    inherit (langchain-core) updateScript;
  };

  meta = {
    description = "Build context-aware reasoning applications";
    homepage = "https://github.com/langchain-ai/langchain";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      sarahec
    ];
  };
}
