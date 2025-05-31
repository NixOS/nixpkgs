{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  symbex,
  llm,
  llm-fragments-symbex,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-fragments-symbex";
  version = "0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-fragments-symbex";
    tag = version;
    hash = "sha256-LECMHv4tGMCY60JU68y2Sfxp97Px7T/RJVhYVDSFCy4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    llm
    symbex
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_fragments_symbex" ];

  passthru.tests = llm.mkPluginTest llm-fragments-symbex;

  meta = {
    description = "LLM fragment loader for Python symbols";
    homepage = "https://github.com/simonw/llm-fragments-symbex";
    changelog = "https://github.com/simonw/llm-fragments-symbex/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
