{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  anyio,
  asyncer,
  cachetools,
  cloudpickle,
  datamodel-code-generator,
  diskcache,
  gepa,
  json-repair,
  litellm,
  mcp,
  numpy,
  openai,
  orjson,
  pillow,
  pydantic,
  pyprojectVersionPatchHook,
  pytestCheckHook,
  pytest-asyncio,
  regex,
  requests,
  tenacity,
  tqdm,
  typeguard,
  xxhash,
}:

buildPythonPackage (finalAttrs: {
  pname = "dspy";
  version = "3.2.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stanfordnlp";
    repo = "dspy";
    tag = finalAttrs.version;
    hash = "sha256-xquV+FyDfejm1SCWYfuiezIkyutmm/1zOvd5X+oElrM=";
  };

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  dependencies = [
    anyio
    asyncer
    cachetools
    cloudpickle
    diskcache
    gepa
    json-repair
    litellm
    mcp
    numpy
    openai
    orjson
    pydantic
    regex
    requests
    tenacity
    tqdm
    typeguard
    xxhash
  ];

  pythonRelaxDeps = [
    "asyncer"
    "gepa"
    "litellm"
    "typeguard"
  ];

  # optuna is an optional dependency that dspy can use but doesn't require at import time
  pythonRemoveDeps = [ "optuna" ];

  # Prevent litellm from trying to fetch the remote model cost map at import
  # time, which fails in environments without direct internet access.
  postPatch = ''
    sed -i '1i import os; os.environ.setdefault("LITELLM_LOCAL_MODEL_COST_MAP", "true")' dspy/__init__.py
  '';

  pythonImportsCheck = [ "dspy" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    datamodel-code-generator
    pillow
  ];

  # skip tests that need network access
  disabledTestPaths = [
    "tests/signatures/test_adapter_image.py"
  ];

  # These tests start a litellm proxy server subprocess, which isn't available
  # in the nix build sandbox (upstream skips them on Python 3.14 for the same reason).
  disabledTests = [
    "test_chat_lms_can_be_queried"
    "test_dspy_cache"
    "test_lm_calls_support_callables"
    "test_lm_calls_support_pydantic_models"
    "test_responses_api_tool_calls"
    "test_streamify_yields_expected_response_chunks"
    "test_streaming_response_yields_expected_response_chunks"
    "test_text_lms_can_be_queried"
  ];

  meta = {
    description = "Programming — not prompting — language models";
    homepage = "https://github.com/stanfordnlp/dspy";
    changelog = "https://github.com/stanfordnlp/dspy/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ jherland ];
    license = lib.licenses.mit;
    # The datamodel-code-generator dependency fails a test on Darwin, but we only need Linux support for now.
    # This prevents rebuilding all of datamodel-code-generator's dependents.
    platforms = lib.platforms.linux;
  };
})
