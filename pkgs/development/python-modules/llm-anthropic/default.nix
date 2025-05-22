{
  lib,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  anthropic,
  pytestCheckHook,
  pytest-asyncio,
  pytest-recording,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-anthropic";
  version = "0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-anthropic";
    tag = version;
    hash = "sha256-oL8jT76jWSJxds9w0/oX0YK9WbfxjsbJ8PTqiirAV7Q=";
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

  passthru.tests = {
    llm-plugin = callPackage ./tests/llm-plugin.nix { };
  };

  meta = {
    description = "LLM access to models by Anthropic, including the Claude series";
    homepage = "https://github.com/simonw/llm-anthropic";
    changelog = "https://github.com/simonw/llm-anthropic/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aos ];
  };
}
