{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  httpx,
  nix-update-script,
  openai,
  openinference-instrumentation,
  openinference-semantic-conventions,
  opentelemetry-api,
  opentelemetry-instrumentation-httpx,
  opentelemetry-instrumentation,
  opentelemetry-semantic-conventions,
  pytest-asyncio,
  pytest-vcr,
  pytestCheckHook,
  respx,
  typing-extensions,
  wrapt,
}:

buildPythonPackage (finalAttrs: {
  pname = "openinference-instrumentation-openai";
  version = "0.1.52";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Arize-ai";
    repo = "openinference";
    tag = "python-openinference-instrumentation-openai-v${finalAttrs.version}";
    hash = "sha256-wmwqmN/rN521TaXVZfkaRzHPVhANSgKaBVc4rhXgIII=";
  };

  sourceRoot = "${finalAttrs.src.name}/python/instrumentation/${finalAttrs.pname}";

  build-system = [ hatchling ];

  dependencies = [
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-semantic-conventions
    openinference-semantic-conventions
    openinference-instrumentation
    typing-extensions
    wrapt
  ];

  optional-dependencies = {
    instruments = [ openai ];
  };

  nativeCheckInputs = [
    httpx
    opentelemetry-instrumentation-httpx
    pytest-asyncio
    pytest-vcr
    pytestCheckHook
    respx
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "openinference.instrumentation.openai" ];

  disabledTests = [
    # Tests want to connect to OpenAI's API
    "test_cached_tokens"
    "test_input_value"
    "test_openai"
    "test_tool_calls"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenInference OpenAI SDK Instrumentation";
    homepage = "https://github.com/Arize-ai/openinference";
    changelog = "https://github.com/Arize-ai/openinference/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
