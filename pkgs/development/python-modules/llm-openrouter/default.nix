{
  lib,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  llm,

  # dependencies
  httpx,
  openai,

  # tests
  pytestCheckHook,
  inline-snapshot,
  pytest-recording,
}:

buildPythonPackage rec {
  pname = "llm-openrouter";
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
    # Follows the reasoning from https://github.com/NixOS/nixpkgs/pull/327800#discussion_r1681586659 about including llm in build-system
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
    maintainers = with lib.maintainers; [ arcuru ];
  };
}
