{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  json-schema-to-pydantic,
  llm,
  llm-anthropic,
  anthropic,
  pytestCheckHook,
  pytest-asyncio,
  pytest-recording,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-anthropic";
  version = "0.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-anthropic";
    tag = finalAttrs.version;
    hash = "sha256-0nI/J7gGTUyrvluez9H8WD4kCuMFgWR5zFHRMxh9DXQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    anthropic
    json-schema-to-pydantic
    llm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-recording
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # Need to be run as a passthru test
    "test_async_prompt"
    "test_image_prompt"
    "test_prompt"
    "test_schema_prompt"
    "test_thinking_prompt"
  ];

  pythonImportsCheck = [ "llm_anthropic" ];

  passthru.tests = llm.mkPluginTest llm-anthropic;

  meta = {
    description = "LLM access to models by Anthropic, including the Claude series";
    homepage = "https://github.com/simonw/llm-anthropic";
    changelog = "https://github.com/simonw/llm-anthropic/releases/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      aos
      sarahec
    ];
  };
})
