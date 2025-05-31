{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-docs,
}:

buildPythonPackage rec {
  pname = "llm-docs";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-docs";
    tag = version;
    hash = "sha256-+Ha6L2h8p/yA073MfO2Uvd6E4bKA2xAvaBWtvjqglOw=";
  };

  build-system = [ setuptools ];

  dependencies = [ llm ];

  pythonImportsCheck = [ "llm_docs" ];

  passthru.tests = llm.mkPluginTest llm-docs;

  meta = {
    description = "Ask questions of LLM documentation using LLM";
    homepage = "https://github.com/simonw/llm-docs";
    changelog = "https://github.com/simonw/llm-docs/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
