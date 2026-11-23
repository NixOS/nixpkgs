{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx2,
  llm,
  llm-venice,
}:

buildPythonPackage rec {
  pname = "llm-venice";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ar-jan";
    repo = "llm-venice";
    tag = version;
    hash = "sha256-7tkPmp/+A4cDouHMSY9AzemXB+jwOW3FwL0OsD/mZl8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx2
    llm
  ];

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
