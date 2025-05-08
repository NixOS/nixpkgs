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
  version = "0.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-anthropic";
    tag = version;
    hash = "sha256-8bVs3MJteOTCiw7n/4pMf+oXMhsQbCSzUFVQqm2ezcE=";
  };

  build-system = [
    setuptools
    llm
  ];

  dependencies = [ anthropic ];

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
    changelog = "https://github.com/simonw/llm-anthropic/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aos ];
  };
}
