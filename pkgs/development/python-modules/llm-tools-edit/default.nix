{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-echo,
  llm-tools-edit,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-tools-edit";
  version = "0.1a0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-tools-edit";
    tag = finalAttrs.version;
    hash = "sha256-mWqZe6gfX16OlTxo20RmjSjmtaS2C1C5iW+KSnHOMdA=";
  };

  build-system = [ setuptools ];

  dependencies = [ llm ];

  nativeCheckInputs = [
    llm-echo
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_tools_edit" ];

  passthru.tests = llm.mkPluginTest llm-tools-edit;

  meta = {
    description = "LLM plugin providing tools for editing files";
    homepage = "https://github.com/simonw/llm-tools-edit";
    changelog = "https://github.com/simonw/llm-tools-edit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
