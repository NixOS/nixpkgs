{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  pyprojectVersionPatchHook,

  # dependencies
  beancount-black,
  beancount-data,
  beancount-exporter,
  beancount-parser,
  beanhub-extract,
  beanhub-forms,
  beanhub-import,
  beanhub-inbox,
  click,
  fastapi,
  fastapi-mcp,
  jinja2,
  orjson,
  pydantic-settings,
  pydantic,
  pyyaml,
  rich,
  starlette-wtf,
  uvicorn,

  # optional-dependencies
  attrs,
  cryptography,
  httpx,
  pynacl,
  python-dateutil,
  tomli-w,
  tomli,

  # tests
  pytest-asyncio,
  pytest-factoryboy,
  pytest-httpx,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "beanhub-cli";
  version = "3.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-cli";
    tag = version;
    hash = "sha256-rac2qu9kqiflQjGASnJtoLEAKP4rEtC0yCntrqNa0cs=";
  };

  pythonRelaxDeps = [
    "httpx"
    "rich"
  ];

  # Tag 3.3.1 left pyproject.toml at 3.3.0
  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ hatchling ];

  dependencies = [
    beancount-black
    beancount-data
    beancount-exporter
    beancount-parser
    beanhub-extract
    beanhub-forms
    beanhub-import
    beanhub-inbox
    click
    fastapi
    fastapi-mcp
    jinja2
    orjson
    pydantic
    pydantic-settings
    pyyaml
    rich
    starlette-wtf
    uvicorn
  ]
  ++ lib.concatAttrValues optional-dependencies;

  optional-dependencies = {
    login = [
      attrs
      httpx
      python-dateutil
      tomli
      tomli-w
    ];
    connect = [
      attrs
      cryptography
      httpx
      pynacl
      python-dateutil
      tomli
      tomli-w
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-factoryboy
    pytest-httpx
    pytest-mock
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTestPaths = [
    # Requires pytest-benchmark
    "tests/benchmark"
  ];

  pythonImportsCheck = [ "beanhub_cli" ];

  meta = {
    description = "Command line tools for BeanHub or Beancount users";
    homepage = "https://github.com/LaunchPlatform/beanhub-cli/";
    changelog = "https://github.com/LaunchPlatform/beanhub-cli/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fangpen ];
    mainProgram = "bh";
  };
}
