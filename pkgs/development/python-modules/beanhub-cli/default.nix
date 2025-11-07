{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  hatchling,

  # dependencies
  beancount-black,
  beancount-parser,
  beanhub-forms,
  beanhub-import,
  beanhub-inbox,
  click,
  fastapi,
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
  pytestCheckHook,
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

  pythonRelaxDeps = [ "rich" ];

  build-system = [ hatchling ];

  dependencies = [
    beancount-black
    beancount-parser
    beanhub-forms
    beanhub-import
    beanhub-inbox
    click
    fastapi
    jinja2
    pydantic
    pydantic-settings
    pyyaml
    rich
    starlette-wtf
    uvicorn
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

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
  ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "beanhub_cli" ];

  meta = {
    description = "Command line tools for BeanHub or Beancount users";
    homepage = "https://github.com/LaunchPlatform/beanhub-cli/";
    changelog = "https://github.com/LaunchPlatform/beanhub-cli/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fangpen ];
    mainProgram = "bh";
  };
}
