{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx,
  httpx-sse,
  llm,
  llm-mistral,
  pytestCheckHook,
  pytest-asyncio,
  pytest-httpx,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-mistral";
  version = "0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-mistral";
    tag = version;
    hash = "sha256-4ajvsq0sm3/vdiHUuNxHsHKdX58VNNpHIwhWI0ws+08=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    httpx
    httpx-sse
    llm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-httpx
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_mistral" ];

  passthru.tests = llm.mkPluginTest llm-mistral;

  meta = {
    description = "LLM plugin providing access to Mistral models using the Mistral API";
    homepage = "https://github.com/simonw/llm-mistral";
    changelog = "https://github.com/simonw/llm-mistral/releases/tag/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
