{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-tools-rag,
  pytestCheckHook,
  sqlite-utils,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-tools-rag";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "daturkel";
    repo = "llm-tools-rag";
    tag = finalAttrs.version;
    hash = "sha256-sFu0Tq7HWg8i4uHyRJP8RKIbhHHge3nAs6Ufv++dE9Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    llm
    sqlite-utils
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_tools_rag" ];

  passthru.tests = llm.mkPluginTest llm-tools-rag;

  meta = {
    description = "LLM tool plugin to enable searching over embeddings";
    homepage = "https://github.com/daturkel/llm-tools-rag";
    changelog = "https://github.com/daturkel/llm-tools-rag/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
