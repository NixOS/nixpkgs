{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx,
  llm,
  llm-public-ai,
  pytest-asyncio,
  pytest-recording,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-public-ai";
  version = "0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-public-ai";
    tag = finalAttrs.version;
    hash = "sha256-QO02izDvIHfMscHpcA88KO1bCMmmn41ivTIGWcJbkMc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    llm
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-recording
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_public_ai" ];

  passthru.tests = llm.mkPluginTest llm-public-ai;

  meta = {
    description = "LLM models from publicai.co";
    homepage = "https://github.com/simonw/llm-public-ai";
    changelog = "https://github.com/simonw/llm-public-ai/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
