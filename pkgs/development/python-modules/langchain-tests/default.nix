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
  version = "0.3.33";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain";
    tag = "langchain-core==${version}";
    hash = "sha256-1bLb81MOQ3062dhutUV4hDf/79DlM5VRFyy32TU6x04=";
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
