{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  giskard-core,
  giskard-llm,
  griffe,
  jinja2,
  logfire-api,
  numpy,
  pydantic,
  tenacity,
  typing-extensions,

  # optional-dependencies
  litellm,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "giskard-agents";
  version = "1.0.2";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Giskard-AI";
    repo = "giskard-oss";
    tag = "giskard-agents/v${finalAttrs.version}";
    hash = "sha256-21ahptjQr5jtNmHDYejSRmy4iJ4E8w6N4QMFa8j/zNc=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/giskard-agents";

  build-system = [ hatchling ];

  dependencies = [
    giskard-core
    giskard-llm
    griffe
    jinja2
    logfire-api
    numpy
    pydantic
    tenacity
    typing-extensions
  ];

  # The google and all extras need google-genai 2.x. Currently, nixpkgs has 1.x.
  optional-dependencies = {
    litellm = [ litellm ];
    openai = giskard-llm.optional-dependencies.openai;
    anthropic = giskard-llm.optional-dependencies.anthropic;
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "giskard.agents" ];

  meta = {
    description = "Library that runs LLM completions and agents in parallel workflows";
    homepage = "https://github.com/Giskard-AI/giskard-oss";
    changelog = "https://github.com/Giskard-AI/giskard-oss/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gquetel ];
  };
})
