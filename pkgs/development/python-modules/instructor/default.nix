{
  lib,
  aiohttp,
  anthropic,
  buildPythonPackage,
  docstring-parser,
  fetchFromGitHub,
  jiter,
  openai,
  poetry-core,
  pydantic,
  pytest-examples,
  pytest-asyncio,
  pytestCheckHook,
  fastapi,
  diskcache,
  redis,
  pythonOlder,
  rich,
  tenacity,
  typer,
}:

buildPythonPackage rec {
  pname = "instructor";
  version = "1.3.7";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jxnl";
    repo = "instructor";
    rev = "refs/tags/${version}";
    hash = "sha256-XouTXv8wNPPBKVs2mCue1o4hfHlPlq6uXBuDXiZLIHI=";
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
    fastapi
    redis
    diskcache
    pytest-asyncio
    pytest-examples
    pytestCheckHook
  ];

  pythonImportsCheck = [ "instructor" ];

  disabledTests = [
    # Tests require OpenAI API key
    "successfully"
    "test_mode_functions_deprecation_warning"
    "test_partial"
  ];

  disabledTestPaths = [
    # Tests require OpenAI API key
    "tests/test_distil.py"
    "tests/llm/"
  ];

  meta = with lib; {
    description = "Structured outputs for llm";
    homepage = "https://github.com/jxnl/instructor";
    changelog = "https://github.com/jxnl/instructor/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    mainProgram = "instructor";
  };
}
