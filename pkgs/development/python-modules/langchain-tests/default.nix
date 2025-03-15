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
  version = "0.3.45";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-core==${version}";
    hash = "sha256-9aAA5HGjZADBppNFd9viIJcIh5RUtPYL8FmdqF0QqX8=";
  };

  sourceRoot = "${src.name}/libs/standard-tests";

  build-system = [ pdm-backend ];

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
