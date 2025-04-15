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
  version = "0.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-gemini";
    tag = version;
    hash = "sha256-CF3kRrW1wV1JZC+spOmb2BFBKjFzvWG+vFIscZuVp2U=";
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
    changelog = "https://github.com/simonw/llm-gemini/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ josh ];
  };
}
