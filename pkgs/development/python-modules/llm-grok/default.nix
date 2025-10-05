{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-grok,
  httpx,
  httpx-sse,
  rich,
  pytestCheckHook,
  pytest-httpx,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-grok";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Hiepler";
    repo = "llm-grok";
    tag = "v${version}";
    hash = "sha256-Z/q7A7lidtDPpuD+xnD7+puWxvUZi4ruO7l1AZEu1vU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    llm
    httpx
    httpx-sse
    rich
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-httpx
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_grok" ];

  passthru.tests = llm.mkPluginTest llm-grok;

  meta = {
    description = "LLM plugin providing access to Grok models using the xAI API";
    homepage = "https://github.com/Hiepler/llm-grok";
    changelog = "https://github.com/Hiepler/llm-grok/releases/tag/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
