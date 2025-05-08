{
  lib,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  nix-update-script,
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

  build-system = [
    setuptools
    llm
  ];

  dependencies = [ ];

  pythonImportsCheck = [ "llm_jq" ];

  passthru.tests = {
    llm-plugin = callPackage ./tests/llm-plugin.nix { };
  };

  meta = {
    description = "Write and execute jq programs with the help of LLM";
    homepage = "https://github.com/simonw/llm-jq";
    changelog = "https://github.com/simonw/llm-jq/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ josh ];
  };
}
