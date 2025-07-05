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
  beanhub-inbox,
  click,
  fastapi,
  hatchling,
  jinja2,
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
  pytest,
}:

buildPythonPackage rec {
  pname = "beanhub-cli";
  version = "3.0.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-cli";
    tag = version;
    hash = "sha256-hreVGsptCGW6L3rj6Ec8+lefZWpQ4tZtUEJI+NxTO7w=";
  };

  pythonRelaxDeps = [
    "rich"
  ];

  build-system = [ hatchling ];

  dependencies = [
    attrs
    beancount-black
    beancount-parser
    beanhub-forms
    beanhub-import
    beanhub-inbox
    click
    cryptography
    fastapi
    httpx
    jinja2
    pydantic
    pydantic-settings
    pynacl
    python-dateutil
    pyyaml
    rich
    starlette-wtf
    tomli
    tomli-w
    uvicorn
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-factoryboy
    pytest-httpx
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "beanhub_cli" ];

  meta = {
    description = "Command line tools for BeanHub or Beancount users";
    mainProgram = "bh";
    homepage = "https://github.com/LaunchPlatform/beanhub-cli/";
    changelog = "https://github.com/LaunchPlatform/beanhub-cli/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fangpen ];
  };
}
