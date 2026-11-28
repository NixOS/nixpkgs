{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  giskard-agents,
  giskard-checks,
  huggingface-hub,
  numpy,

  # tests
  httpx,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "giskard-scan";
  version = "1.0.0";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Giskard-AI";
    repo = "giskard-oss";
    tag = "giskard-scan/v${finalAttrs.version}";
    hash = "sha256-FEMoYUX6boLHpZifHEynHF7QqL/x+PC8BVQYaVYErkc=";
  };

  # All the giskard libraries are in one repository.
  sourceRoot = "${finalAttrs.src.name}/libs/giskard-scan";

  build-system = [ hatchling ];

  dependencies = [
    giskard-agents
    giskard-checks
    huggingface-hub
    numpy
  ];

  # This package has no extras. The garak and deepteam extras need packages
  # that are not in nixpkgs.

  nativeCheckInputs = [
    httpx
    pytest-asyncio
    pytestCheckHook
  ];

  # Don't attempt connections during build.
  env.DO_NOT_TRACK = "1";

  pythonImportsCheck = [ "giskard.scan" ];

  meta = {
    description = "Vulnerability scanner for agents with red teaming and prompt injection";
    homepage = "https://github.com/Giskard-AI/giskard-oss";
    changelog = "https://github.com/Giskard-AI/giskard-oss/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gquetel ];
  };
})
