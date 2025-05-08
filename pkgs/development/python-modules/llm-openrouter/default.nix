{
  lib,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  httpx,
  openai,
  pytestCheckHook,
  inline-snapshot,
  pytest-recording,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "openrouter";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-openrouter";
    tag = version;
    hash = "sha256-ojBkyXqEaqTcOv7mzTWL5Ihhb50zeVzeQZNA6DySuVg=";
  };

  build-system = [
    setuptools
    llm
  ];

  dependencies = [
    httpx
    openai
  ];

  nativeCheckInputs = [
    pytestCheckHook
    inline-snapshot
    pytest-recording
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_openrouter" ];

  passthru.tests = {
    llm-plugin = callPackage ./tests/llm-plugin.nix { };
  };

  meta = {
    description = "LLM plugin for models hosted by OpenRouter";
    homepage = "https://github.com/simonw/llm-openrouter";
    changelog = "https://github.com/simonw/llm-openrouter/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
