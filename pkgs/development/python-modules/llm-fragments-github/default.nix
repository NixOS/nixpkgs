{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-fragments-github,
}:

buildPythonPackage rec {
  pname = "llm-fragments-github";
  version = "0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-fragments-github";
    tag = version;
    hash = "sha256-+MNFj7auB/dUSIBDXOBaKjIYIW18GLDB55l66S37U1A=";
  };

  build-system = [
    setuptools
    llm
  ];
  dependencies = [ ];

  pythonImportsCheck = [ "llm_fragments_github" ];

  passthru.tests = llm.mkPluginTest llm-fragments-github;

  meta = {
    description = "Load GitHub repository contents as LLM fragments";
    homepage = "https://github.com/simonw/llm-fragments-github";
    changelog = "https://github.com/simonw/llm-fragments-github/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
