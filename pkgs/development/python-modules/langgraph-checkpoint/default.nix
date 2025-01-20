{
  lib,
  buildPythonPackage,
  dataclasses-json,
  fetchFromGitHub,
  langchain-core,
  langgraph-sdk,
  msgpack,
  poetry-core,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint";
  version = "2.0.13";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpointpostgres==${version}";
    hash = "sha256-Vz2ZoikEZuMvt3j9tvBIcXCwWSrCV8MI7x9PIHodl8Y=";
  };

  sourceRoot = "${src.name}/libs/checkpoint";

  build-system = [ poetry-core ];

  dependencies = [ langchain-core ];

  propagatedBuildInputs = [ msgpack ];

  pythonRelaxDeps = [ "msgpack" ]; # Can drop after msgpack 1.0.10 lands in nixpkgs

  pythonImportsCheck = [ "langgraph.checkpoint" ];

  nativeCheckInputs = [
    dataclasses-json
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError
    "test_serde_jsonplus"
  ];

  passthru = {
    updateScript = langgraph-sdk.updateScript;
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/checkpoint==${src.tag}";
    description = "Library with base interfaces for LangGraph checkpoint savers";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/checkpoint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      sarahec
    ];
  };
}
