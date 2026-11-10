{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-openrouter,
  httpx,
  openai,
  pytestCheckHook,
  inline-snapshot,
  pytest-recording,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-openrouter";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-openrouter";
    tag = version;
    hash = "sha256-KC1+W5OEBoxsXxh7zoQQGrjyW5KBwkFP01KTKTNIk5Q=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    httpx
    llm
    openai
  ];

  nativeCheckInputs = [
    pytestCheckHook
    inline-snapshot
    pytest-recording
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_openrouter" ];

  passthru.tests = llm.mkPluginTest llm-openrouter;

  meta = {
    description = "LLM plugin for models hosted by OpenRouter";
    homepage = "https://github.com/simonw/llm-openrouter";
    changelog = "https://github.com/simonw/llm-openrouter/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      arcuru
      philiptaron
    ];
  };
}
