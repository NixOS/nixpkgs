{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # Dependencies
  setuptools,
  click,
  fastapi,
  python-dotenv,
  slowapi,
  starlette,
  tiktoken,
  tomli,
  uvicorn,

  # Tests
  httpx,
  jinja2,
  pytestCheckHook,
  python-multipart,
}:

buildPythonPackage rec {
  pname = "gitingest";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cyclotruc";
    repo = "gitingest";
    tag = "v${version}";
    hash = "sha256-RGrenW0modLH9h5pQOexPvEDQ9Bczoj1qInYmgUoGdo=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "fastapi"
  ];

  dependencies = [
    click
    fastapi
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
    pytestCheckHook
    python-multipart
  ];

  disabledTests = [
    # Tests require network
    "test_cli_with_default_options"
    "test_cli_with_options"
    "test_run_ingest_query"
  ];

  meta = {
    changelog = "https://github.com/cyclotruc/gitingest/releases/tag/v${version}";
    description = "Replace 'hub' with 'ingest' in any github url to get a prompt-friendly extract of a codebase";
    homepage = "https://github.com/cyclotruc/gitingest";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "gitingest";
  };
}
