{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-jq,
}:
buildPythonPackage rec {
  pname = "llm-jq";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-jq";
    tag = version;
    hash = "sha256-Mf/tbB9+UdmSRpulqv5Wagr8wjDcRrNs2741DNQZhO4=";
  };

  build-system = [ setuptools ];

  dependencies = [ llm ];

  pythonImportsCheck = [ "llm_jq" ];

  passthru.tests = llm.mkPluginTest llm-jq;

  meta = {
    description = "Write and execute jq programs with the help of LLM";
    homepage = "https://github.com/simonw/llm-jq";
    changelog = "https://github.com/simonw/llm-jq/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      erethon
      josh
      philiptaron
    ];
  };
}
