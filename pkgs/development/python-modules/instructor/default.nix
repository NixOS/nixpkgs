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
  version = "1.3.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jxnl";
    repo = "instructor";
    rev = "refs/tags/${version}";
    hash = "sha256-ye6uNnwvJ3RXmKM8ix/sBiJgeCFQazNVgHZkBAnL0nw=";
  };

  pythonRelaxDeps = [
    "docstring-parser"
    "pydantic"
    "jiter"
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
    "test_partial"
    "successfully"
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
