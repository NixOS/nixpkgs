{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-gemini,
  httpx,
  ijson,
  pytestCheckHook,
  pytest-recording,
  pytest-asyncio,
  nest-asyncio,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage rec {
  pname = "llm-gemini";
  version = "0.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-gemini";
    tag = version;
    hash = "sha256-8zUOP+LNwdUXx4hR3m5lodcVUmB4ZjyiWqWzk2tV9wM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    ijson
    llm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-recording
    pytest-asyncio
    nest-asyncio
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_gemini" ];

  passthru.tests = llm.mkPluginTest llm-gemini;

  meta = {
    description = "LLM plugin to access Google's Gemini family of models";
    homepage = "https://github.com/simonw/llm-gemini";
    changelog = "https://github.com/simonw/llm-gemini/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ josh ];
  };
}
