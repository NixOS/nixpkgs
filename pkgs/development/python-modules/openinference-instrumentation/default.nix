{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  jsonschema,
  nix-update-script,
  openai,
  openinference-semantic-conventions,
  opentelemetry-api,
  opentelemetry-sdk,
  pytest-asyncio,
  pytest-vcr,
  pytestCheckHook,
  typing-extensions,
  wrapt,
}:

buildPythonPackage (finalAttrs: {
  pname = "openinference-instrumentation";
  version = "0.1.54";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Arize-ai";
    repo = "openinference";
    tag = "python-openinference-instrumentation-v${finalAttrs.version}";
    hash = "sha256-6GWZmgb9ZcT/yx7MvGUQlht5fljQGCKMHMpJWZQKpPI=";
  };

  sourceRoot = "${finalAttrs.src.name}/python/${finalAttrs.pname}";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-sdk
    openinference-semantic-conventions
    typing-extensions
    wrapt
  ];

  nativeCheckInputs = [
    jsonschema
    openai
    pytest-asyncio
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [ "openinference.instrumentation" ];

  disabledTests = [
    # Tests want to connect to OpenAI's API
    "TestTracerLLMDecorator"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenTelemetry Instrumentation for AI Observability";
    homepage = "https://github.com/Arize-ai/openinference";
    changelog = "https://github.com/Arize-ai/openinference/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
