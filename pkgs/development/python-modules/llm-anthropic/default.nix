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
  version = "0.25.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-anthropic";
    tag = finalAttrs.version;
    hash = "sha256-b9XnPxKDGsiy20Me70sYrkMVO36OF3EwWOHLyEd5z4E=";
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

    # TypeError: Messages.stream() got an unexpected keyword argument 'temperature'
    "test_image_with_no_prompt"
    "test_url_prompt"
    "test_tools"
    "test_web_search"
    "test_opus_46_prompt"
    "test_sonnet_46_prompt"
    "test_opus_46_adaptive_thinking"
    "test_sonnet_46_effort_without_thinking"
    "test_opus_46_schema"
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
