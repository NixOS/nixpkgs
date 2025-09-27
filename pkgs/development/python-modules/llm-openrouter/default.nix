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
  version = "0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-openrouter";
    tag = version;
    hash = "sha256-lofijdGKkQRQa2Hle4puIBOj+I28hGdKRILeQZOLkz4=";
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
