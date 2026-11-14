{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  exa-py,
  llm,
  llm-tools-exa,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-tools-exa";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "daturkel";
    repo = "llm-tools-exa";
    tag = finalAttrs.version;
    hash = "sha256-LOG9j0LtUw4ZYXFLnsiIChXI4j4hHA7WjXGqNLCwew0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    exa-py
    llm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_tools_exa" ];

  passthru.tests = llm.mkPluginTest llm-tools-exa;

  meta = {
    description = "LLM tool plugin to enable web search with Exa";
    homepage = "https://github.com/daturkel/llm-tools-exa";
    changelog = "https://github.com/daturkel/llm-tools-exa/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
