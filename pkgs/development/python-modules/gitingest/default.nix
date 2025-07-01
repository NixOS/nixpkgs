{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # Dependencies
  setuptools,
  click,
  fastapi,
  pathspec,
  pydantic,
  python-dotenv,
  slowapi,
  starlette,
  tiktoken,
  tomli,
  uvicorn,

  # Tests
  httpx,
  jinja2,
  gitMinimal,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  python-multipart,
}:

buildPythonPackage rec {
  pname = "gitingest";
  version = "0.1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cyclotruc";
    repo = "gitingest";
    tag = "v${version}";
    hash = "sha256-f/srwLhTXboSlW28qnShqTuc2yLMuHH3MyzfKpDIitQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    click
    fastapi
    pathspec
    pydantic
    python-dotenv
    slowapi
    starlette
    tiktoken
    tomli
    uvicorn
  ];

  pythonImportsCheck = [
    "gitingest"
  ];

  nativeCheckInputs = [
    httpx
    jinja2
    gitMinimal
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    python-multipart
  ];

  disabledTests = [
    # Tests require network
    "test_cli_with_default_options"
    "test_cli_with_options"
    "test_cli_with_stdout_output"
    "test_cli_writes_file"
    "test_clone_specific_branch"
    "test_include_ignore_patterns"
    "test_ingest_with_gitignore"
    "test_parse_query_with_branch"
    "test_parse_query_without_host"
    "test_run_ingest_query"
  ];

  meta = {
    changelog = "https://github.com/cyclotruc/gitingest/releases/tag/${src.tag}";
    description = "Replace 'hub' with 'ingest' in any github url to get a prompt-friendly extract of a codebase";
    homepage = "https://github.com/cyclotruc/gitingest";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "gitingest";
  };
}
