{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  anyio,
  httpx,
  httpx-ws,
  msgspec,
  typing-extensions,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lmstudio";
  version = "1.6.0b1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lmstudio-ai";
    repo = "lmstudio-python";
    tag = finalAttrs.version;
    hash = "sha256-QJNVlkSmwinoJ/cMCDpYzYDmd6Q8AGiLHHdk36Fqtk8=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    anyio
    httpx
    httpx-ws
    msgspec
    typing-extensions
  ];

  pythonImportsCheck = [ "lmstudio" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # lmstudio.LMStudioRuntimeError: Local API host port is not yet resolved.
    "test_session_disconnected_async"
  ];

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'pytest_subtests'
    "tests/async/test_model_catalog_async.py"
    "tests/sync/test_model_catalog_sync.py"
    "tests/test_inference.py"

    # lmstudio.LMStudioRuntimeError: Local API host port is not yet resolved.
    "tests/async/test_embedding_async.py"
    "tests/async/test_images_async.py"
    "tests/async/test_inference_async.py"
    "tests/async/test_llm_async.py"
    "tests/async/test_model_handles_async.py"
    "tests/async/test_repository_async.py"
    "tests/async/test_sdk_bypass_async.py"
    "tests/sync/test_embedding_sync.py"
    "tests/sync/test_images_sync.py"
    "tests/sync/test_inference_sync.py"
    "tests/sync/test_llm_sync.py"
    "tests/sync/test_model_handles_sync.py"
    "tests/sync/test_repository_sync.py"
    "tests/sync/test_sdk_bypass_sync.py"
    "tests/test_convenience_api.py"
    "tests/test_logging.py"
    "tests/test_plugin_examples.py"
    "tests/test_sessions.py"
    "tests/test_timeouts.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "LM Studio Python SDK";
    homepage = "https://github.com/lmstudio-ai/lmstudio-python";
    changelog = "https://github.com/lmstudio-ai/lmstudio-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
