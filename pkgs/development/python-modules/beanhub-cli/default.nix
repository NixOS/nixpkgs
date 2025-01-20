{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,

  # dependencies
  beancount-black,
  beancount-parser,
  beanhub-forms,
  beanhub-import,
  click,
  fastapi,
  jinja2,
  poetry-core,
  pydantic-core,
  pydantic-settings,
  pydantic,
  pytz,
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
  pytest,
  pytest-asyncio,
  pytest-httpx,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "beanhub-cli";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-cli";
    tag = version;
    hash = "sha256-PRhodc0Pjcgx2xjYlBI47JsQ0oLX6hrVLyE58LHoxSw=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    beancount-black
    beancount-parser
    beanhub-forms
    beanhub-import
    click
    fastapi
    jinja2
    pydantic
    pydantic-core
    pydantic-settings
    pytz
    pyyaml
    rich
    starlette-wtf
    uvicorn
  ] ++ optional-dependencies.all;

  optional-dependencies = rec {
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
    all = login ++ connect;
  };

  nativeCheckInputs = [
    pytest
    pytest-asyncio
    pytest-httpx
    pytest-mock
    pytestCheckHook
  ] ++ optional-dependencies.all;

  pythonImportsCheck = [ "beanhub_cli" ];

  meta = {
    description = "Command line tools for BeanHub or Beancount users";
    mainProgram = "bh";
    homepage = "https://github.com/LaunchPlatform/beanhub-cli/";
    changelog = "https://github.com/LaunchPlatform/beanhub-cli/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
