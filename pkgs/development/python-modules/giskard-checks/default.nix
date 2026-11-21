{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  giskard-agents,
  giskard-core,
  jinja2,
  jsonpath-ng,
  jsonschema,
  numpy,
  pydantic,
  pydantic-settings,
  regex,
  rich,

  # optional-dependencies
  textstat,

  # tests
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "giskard-checks";
  version = "1.0.3";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Giskard-AI";
    repo = "giskard-oss";
    tag = "giskard-checks/v${finalAttrs.version}";
    hash = "sha256-2ROTkkGw8GQNT1kK7RhUiK6HR2os1nInx2qki/juE3U=";
  };

  # All the giskard libraries are in one repository.
  sourceRoot = "${finalAttrs.src.name}/libs/giskard-checks";

  build-system = [ hatchling ];

  dependencies = [
    giskard-agents
    giskard-core
    jinja2
    jsonpath-ng
    jsonschema
    numpy
    pydantic
    pydantic-settings
    regex
    rich
  ];

  # TODO: package regorus from GitHub, then add it here. It's an optional
  # dependency so the package works fine.
  optional-dependencies = {
    readability = [ textstat ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
    textstat
  ];

  # Needs regorus
  disabledTests = [
    "test_no_match_on_key_fails"
    "test_serialization_round_trip"
  ];

  # Needs regorus
  disabledTestPaths = [ "src/giskard/checks/builtin/rego_policy.py" ];

  pythonImportsCheck = [ "giskard.checks" ];

  meta = {
    description = "Scenario evaluations and LLM-as-judge checks for agentic systems";
    homepage = "https://github.com/Giskard-AI/giskard-oss";
    changelog = "https://github.com/Giskard-AI/giskard-oss/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gquetel ];
  };
})
