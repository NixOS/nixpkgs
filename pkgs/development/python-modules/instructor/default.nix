{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,

  # dependencies
  aiohttp,
  docstring-parser,
  jinja2,
  jiter,
  openai,
  pydantic,
  requests,
  rich,
  tenacity,
  typer,

  # tests
  anthropic,
  diskcache,
  fastapi,
  google-genai,
  google-generativeai,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  redis,
}:

buildPythonPackage rec {
  pname = "instructor";
  version = "1.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jxnl";
    repo = "instructor";
    tag = "v${version}";
    hash = "sha256-vknPfRHyLoLo2838p/fbjrqyaBORZzLp9+fN98yVDz0=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [
    "jiter"
    "openai"
    "rich"
  ];

  dependencies = [
    aiohttp
    docstring-parser
    jinja2
    jiter
    openai
    pydantic
    requests
    rich
    tenacity
    typer
  ];

  nativeCheckInputs = [
    anthropic
    diskcache
    fastapi
    google-genai
    google-generativeai
    pytest-asyncio
    pytestCheckHook
    python-dotenv
    redis
  ];

  pythonImportsCheck = [ "instructor" ];

  disabledTests = [
    # Tests require OpenAI API key
    "successfully"
    "test_mode_functions_deprecation_warning"
    "test_partial"

    # Requires unpackaged `vertexai`
    "test_json_preserves_description_of_non_english_characters_in_json_mode"

    # Checks magic values and this fails on Python 3.13
    "test_raw_base64_autodetect_jpeg"
    "test_raw_base64_autodetect_png"

    # Performance benchmarks that sometimes fail when running many parallel builds
    "test_combine_system_messages_benchmark"
    "test_extract_system_messages_benchmark"

    # pydantic validation mismatch
    "test_control_characters_not_allowed_in_anthropic_json_strict_mode"
    "test_control_characters_allowed_in_anthropic_json_non_strict_mode"
  ];

  disabledTestPaths = [
    # Tests require OpenAI API key
    "tests/llm/"
    # Network and requires API keys
    "tests/test_auto_client.py"
    # annoying dependencies
    "tests/docs"
    "examples"
  ];

  meta = {
    description = "Structured outputs for llm";
    homepage = "https://github.com/jxnl/instructor";
    changelog = "https://github.com/jxnl/instructor/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
    mainProgram = "instructor";
  };
}
