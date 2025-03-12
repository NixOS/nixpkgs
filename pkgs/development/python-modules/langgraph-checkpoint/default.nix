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
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint";
  version = "2.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    tag = "checkpoint==${version}";
    hash = "sha256-Bs8XWSyI/6a756iWXT40vvNIe/XZ/vnMsZbXjTW3770=";
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
    skipBulkUpdate = true; # Broken, see https://github.com/NixOS/nixpkgs/issues/379898
  };

  meta = {
    changelog = "https://github.com/langchain-ai/langgraph/releases/tag/checkpoint==${version}";
    description = "Library with base interfaces for LangGraph checkpoint savers";
    homepage = "https://github.com/langchain-ai/langgraph/tree/main/libs/checkpoint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      drupol
      sarahec
    ];
  };
}
