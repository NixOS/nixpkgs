{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-anthropic,
  anthropic,
  pytestCheckHook,
  pytest-asyncio,
  pytest-recording,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-anthropic";
  version = "0.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-anthropic";
    tag = version;
    hash = "sha256-eyB68wPc4ALnEypUXN20ru7UfS6yKLp2NJohH3Av9Ls=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    anthropic
    llm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-recording
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_anthropic" ];

  passthru.tests = llm.mkPluginTest llm-anthropic;

  meta = {
    description = "LLM access to models by Anthropic, including the Claude series";
    homepage = "https://github.com/simonw/llm-anthropic";
    changelog = "https://github.com/simonw/llm-anthropic/releases/tag/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aos ];
  };
}
