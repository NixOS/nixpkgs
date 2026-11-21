{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  giskard-core,
  pydantic,

  # optional-dependencies
  anthropic,
  openai,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "giskard-llm";
  version = "1.0.0";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Giskard-AI";
    repo = "giskard-oss";
    tag = "giskard-llm/v${finalAttrs.version}";
    hash = "sha256-alH/c9hc6/h/Z5QRxqMAbJYY4fpXsFcp8YDgENwmGVQ=";
  };

  # All the giskard libraries are in one repository.
  sourceRoot = "${finalAttrs.src.name}/libs/giskard-llm";

  build-system = [ hatchling ];

  dependencies = [
    giskard-core
    pydantic
  ];

  # The google and all extras need google-genai 2.x. nixpkgs has 1.x.
  optional-dependencies = {
    openai = [ openai ];
    anthropic = [ anthropic ];
    azure = [ openai ];
  };

  nativeCheckInputs = [
    anthropic
    openai
    pytest-asyncio
    pytestCheckHook
  ];

  # Don't attempt connections during build.
  env.DO_NOT_TRACK = "1";

  disabledTestPaths = [
    # These tests call the provider APIs.
    "tests/functional"
    # These tests look for google-genai 2.x. nixpkgs has 1.x, so pytest fails
    # when it loads them.
    "tests/test_smoke.py"
    "tests/translators/test_google_chat.py"
    "tests/translators/test_google_response.py"
  ];

  pythonImportsCheck = [ "giskard.llm" ];

  meta = {
    description = "Routing layer for LLM providers used by the Giskard libraries";
    homepage = "https://github.com/Giskard-AI/giskard-oss";
    changelog = "https://github.com/Giskard-AI/giskard-oss/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gquetel ];
  };
})
