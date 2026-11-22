{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-all-models-async,
  pytest-asyncio,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-all-models-async";
  version = "0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-all-models-async";
    tag = finalAttrs.version;
    hash = "sha256-fO0rsW2THOuki2uped0HJtpKpL7PpDawF0hV9OOUBvc=";
  };

  build-system = [ setuptools ];

  dependencies = [ llm ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_all_models_async" ];

  passthru.tests = llm.mkPluginTest llm-all-models-async;

  meta = {
    description = "Make all LLM sync models available as async";
    homepage = "https://github.com/simonw/llm-all-models-async";
    changelog = "https://github.com/simonw/llm-all-models-async/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
