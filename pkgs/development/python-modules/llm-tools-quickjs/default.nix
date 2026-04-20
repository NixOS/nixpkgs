{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  quickjs,
  llm,
  llm-tools-quickjs,
  llm-echo,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-tools-quickjs";
  version = "0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-tools-quickjs";
    tag = version;
    hash = "sha256-Si3VcHnRUj8Q/N8pRhltPOM6K64TX9DBH/u4WQxQJjQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    llm
    quickjs
  ];

  nativeCheckInputs = [
    llm-echo
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_tools_quickjs" ];

  passthru.tests = llm.mkPluginTest llm-tools-quickjs;

  meta = {
    description = "JavaScript execution as a tool for LLM";
    homepage = "https://github.com/simonw/llm-tools-quickjs";
    changelog = "https://github.com/simonw/llm-tools-quickjs/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
