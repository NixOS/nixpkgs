{
  lib,
  buildPythonPackage,
  aiosqlite,
  dataclasses-json,
  fetchFromGitHub,
  grandalf,
  httpx,
  langchain-core,
  langgraph-sdk,
  langsmith,
  poetry-core,
  pydantic,
  pytest-asyncio,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  syrupy,
}:

buildPythonPackage rec {
  pname = "langgraph";
  version = "0.1.9";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    rev = "refs/tags/${version}";
    hash = "sha256-sBjSfKzcILkHgvo8g/NHC+/yUjQSyZB/8xaSCY3rPDs=";
  };

  sourceRoot = "${src.name}/libs/langgraph";

  build-system = [ poetry-core ];

  dependencies = [ langchain-core ];

  pythonImportsCheck = [ "langgraph" ];

  nativeCheckInputs = [
    aiosqlite
    dataclasses-json
    grandalf
    httpx
    langsmith
    pydantic
    pytest-asyncio
    pytest-mock
    pytest-xdist
    pytestCheckHook
    syrupy
  ];

  pytestFlagsArray = [ "--snapshot-update" ];

  disabledTests = [
    "test_doesnt_warn_valid_schema" # test is flaky due to pydantic error on the exception
  ];

  passthru = {
    updateScript = langgraph-sdk.updateScript;
  };

  meta = {
    description = "Build resilient language agents as graphs";
    homepage = "https://github.com/langchain-ai/langgraph";
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
