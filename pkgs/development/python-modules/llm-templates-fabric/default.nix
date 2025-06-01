{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-templates-fabric,
}:

buildPythonPackage rec {
  pname = "llm-templates-fabric";
  version = "0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-templates-fabric";
    tag = version;
    hash = "sha256-tfkSjeT9WstUsNCtVr3fMzqELFCtfYphqf3xFGvHaV0=";
  };

  build-system = [ setuptools ];

  dependencies = [ llm ];

  pythonImportsCheck = [ "llm_templates_fabric" ];

  passthru.tests = llm.mkPluginTest llm-templates-fabric;

  meta = {
    description = "Load LLM templates from Fabric";
    homepage = "https://github.com/simonw/llm-templates-fabric";
    changelog = "https://github.com/simonw/llm-templates-fabric/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
