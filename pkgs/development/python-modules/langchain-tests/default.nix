{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

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
  version = "0.3.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-tests==${version}";
    hash = "sha256-IZJo4EZFVKinBQdacM5xQ8ip3qTB64eqwZ9n+Z5mzWY=";
  };

  sourceRoot = "${src.name}/libs/standard-tests";

  build-system = [ poetry-core ];

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
