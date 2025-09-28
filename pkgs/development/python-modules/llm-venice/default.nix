{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-venice,
}:

buildPythonPackage rec {
  pname = "llm-venice";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ar-jan";
    repo = "llm-venice";
    tag = version;
    hash = "sha256-jvZWMEJAWlX2y2Mivi8Kib5tbMtf+CXYP6fmLvNmD9k=";
  };

  build-system = [ setuptools ];

  dependencies = [ llm ];

  # Reaches out to the real API
  doCheck = false;

  pythonImportsCheck = [ "llm_venice" ];

  passthru.tests = llm.mkPluginTest llm-venice;

  meta = {
    description = "LLM plugin to access models available via the Venice API";
    homepage = "https://github.com/ar-jan/llm-venice";
    changelog = "https://github.com/ar-jan/llm-venice/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
