{
  lib,
  buildPythonPackage,
  dataclasses-json,
  fetchFromGitHub,
  langchain-core,
  langgraph-sdk,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "langgraph-checkpoint";
  version = "1.0.9";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "langchain-ai";
    repo = "langgraph";
    rev = "refs/tags/checkpoint==${version}";
    hash = "sha256-3gm+L67pPAKpY1kqnX1lPnca40KoBVZdRZ1Cy6D0dzU=";
  };

  sourceRoot = "${src.name}/libs/checkpoint";

  build-system = [ poetry-core ];

  dependencies = [ langchain-core ];

  pythonImportsCheck = [ "langgraph.checkpoint" ];

  nativeCheckInputs = [
    dataclasses-json
    pytest-asyncio
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
