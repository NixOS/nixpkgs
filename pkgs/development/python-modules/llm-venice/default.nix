{
  lib,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
}:

buildPythonPackage rec {
  pname = "llm-venice";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ar-jan";
    repo = "llm-venice";
    tag = version;
    hash = "sha256-fHCAERIFhuovo1f+jTG6L4C/Rql8tdHZG/7p5fBLkH0=";
  };

  build-system = [
    setuptools
    llm
  ];

  dependencies = [ ];

  # Reaches out to the real API
  doCheck = false;

  pythonImportsCheck = [ "llm_venice" ];

  passthru.tests = {
    llm-plugin = callPackage ./tests/llm-plugin.nix { };
  };

  meta = {
    description = "LLM plugin to access models available via the Venice API";
    homepage = "https://github.com/ar-jan/llm-venice";
    changelog = "https://github.com/ar-jan/llm-venice/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
