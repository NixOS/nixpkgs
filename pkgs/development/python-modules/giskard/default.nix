{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  giskard-checks,

  # optional-dependencies
  giskard-agents,
  giskard-llm,
  giskard-scan,
}:

buildPythonPackage (finalAttrs: {
  pname = "giskard";
  version = "3.0.0";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Giskard-AI";
    repo = "giskard-oss";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KzvXI5kBQ4bLr64ZsUhYfqQaPer88Oa59IZxy2kXdkI=";
  };

  build-system = [ hatchling ];

  dependencies = [ giskard-checks ];

  # The google, regorus, garak, deepteam and aggregate extras are missing.
  # They need packages that are not in nixpkgs.
  optional-dependencies = {
    openai = [ giskard-llm ] ++ giskard-llm.optional-dependencies.openai;
    anthropic = [ giskard-llm ] ++ giskard-llm.optional-dependencies.anthropic;
    azure = [ giskard-llm ] ++ giskard-llm.optional-dependencies.azure;
    litellm = [ giskard-agents ] ++ giskard-agents.optional-dependencies.litellm;
    scan = [ giskard-scan ];
  };

  # This package is placeholder. The code and the tests are in the other
  # giskard packages.
  doCheck = false;

  pythonImportsCheck = [ "giskard.checks" ];

  meta = {
    description = "Evals, red teaming and test generation for agentic systems";
    homepage = "https://github.com/Giskard-AI/giskard-oss";
    changelog = "https://github.com/Giskard-AI/giskard-oss/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gquetel ];
  };
})
