{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  aiohttp,
  docstring-parser,
  jiter,
  openai,
  pydantic,
  rich,
  tenacity,
  typer,

  # tests
  anthropic,
  diskcache,
  fastapi,
  google-generativeai,
  jinja2,
  pytest-asyncio,
  pytestCheckHook,
  python-dotenv,
  redis,
}:

buildPythonPackage rec {
  pname = "instructor";
  version = "1.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jxnl";
    repo = "instructor";
    rev = "refs/tags/${version}";
    hash = "sha256-iPTZFXypcpO+PkcJHTdpkpiIU589XPcy+aNO/JqASCQ=";
  };

  pythonRelaxDeps = [
    "docstring-parser"
    "jiter"
    "pydantic"
    "tenacity"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    docstring-parser
    jiter
    openai
    pydantic
    rich
    tenacity
    typer
  ];

  nativeCheckInputs = [
    anthropic
    diskcache
    fastapi
    google-generativeai
    jinja2
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
  ];

  disabledTestPaths = [
    # Tests require OpenAI API key
    "tests/test_distil.py"
    "tests/llm/"
  ];

  meta = {
    broken = lib.versionOlder pydantic.version "2"; # ImportError: cannot import name 'TypeAdapter' from 'pydantic'
    description = "Structured outputs for llm";
    homepage = "https://github.com/jxnl/instructor";
    changelog = "https://github.com/jxnl/instructor/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
    mainProgram = "instructor";
  };
}
