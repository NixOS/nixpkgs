{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  bottleneck,
  google-cloud-aiplatform,
  google-cloud-storage,
  google-cloud-vectorsearch,
  httpx,
  httpx-sse,
  langchain-core,
  numexpr,
  pyarrow,
  pydantic,
  validators,
  anthropic,
  freezegun,
  google-api-python-client,
  langchain,
  langchain-tests,
  pytest-asyncio,
  pytest-mock,
  pytest-recording,
  pytest-socket,
  pytestCheckHook,
  syrupy,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "langchain-google-vertexai";
  version = "3.2.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langchain-google";
    tag = "libs/vertexai/v${finalAttrs.version}";
    hash = "sha256-Z3BJLLi1NZ0vDjP4WvmT1fRK0l2lDUqpCfFLQ1G++U8=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/vertexai";

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "pyarrow" ];

  dependencies = [
    bottleneck
    google-cloud-aiplatform
    google-cloud-storage
    google-cloud-vectorsearch
    httpx
    httpx-sse
    langchain-core
    numexpr
    pyarrow
    pydantic
    validators
  ];

  optional-dependencies.anthropic = [ anthropic ];

  nativeCheckInputs = [
    anthropic
    freezegun
    google-api-python-client
    langchain
    langchain-tests
    pytest-asyncio
    pytest-mock
    pytest-recording
    pytest-socket
    pytestCheckHook
    syrupy
  ];

  enabledTestPaths = [ "tests/unit_tests" ];

  pythonImportsCheck = [ "langchain_google_vertexai" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=libs/vertexai/v(.*)" ];
  };

  meta = {
    description = "Integration package connecting Google VertexAI and LangChain";
    homepage = "https://github.com/langchain-ai/langchain-google/tree/main/libs/vertexai";
    changelog = "https://github.com/langchain-ai/langchain-google/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaravrav ];
  };
})
