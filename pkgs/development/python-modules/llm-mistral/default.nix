{
  lib,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx,
  httpx-sse,
  llm,
  pytestCheckHook,
  pytest-asyncio,
  pytest-httpx,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-mistral";
  version = "0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-mistral";
    tag = version;
    hash = "sha256-oNA5NFI4BZMG/V+eSHfuF/JKBX2Xr/L8EK+mf7KjPD0=";
  };

  build-system = [
    setuptools
    llm
  ];

  dependencies = [
    httpx
    httpx-sse
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-httpx
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_mistral" ];

  passthru.tests = {
    llm-plugin = callPackage ./tests/llm-plugin.nix { };
  };

  meta = {
    description = "LLM plugin providing access to Mistral models using the Mistral API";
    homepage = "https://github.com/simonw/llm-mistral";
    changelog = "https://github.com/simonw/llm-mistral/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
