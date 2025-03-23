{
  lib,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
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
  version = "0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-gemini";
    tag = version;
    hash = "sha256-NNzorEb3dVoKef+9eXzStcFAkQhnhMBVnwLBc2lA2+o=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    llm
    httpx
    ijson
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-recording
    pytest-asyncio
    nest-asyncio
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_gemini" ];

  passthru.tests = {
    llm-plugin = callPackage ./tests/llm-plugin.nix { };
  };

  meta = {
    description = "LLM plugin to access Google's Gemini family of models";
    homepage = "https://github.com/simonw/llm-gemini";
    changelog = "https://github.com/simonw/llm-gemini/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ josh ];
  };
}
