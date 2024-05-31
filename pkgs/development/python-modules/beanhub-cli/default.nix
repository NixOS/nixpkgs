{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  pytestCheckHook,
  beancount-black,
  beancount-parser,
  beanhub-forms,
  beanhub-import,
  click,
  fastapi,
  httpx,
  jinja2,
  poetry-core,
  pydantic,
  pydantic-core,
  pydantic-settings,
  pytz,
  pyyaml,
  rich,
  starlette-wtf,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "beanhub-cli";
  version = "1.1.3";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-vYBbaUVJAs+aIp6aQpJb62DEDxe/sQTzgOkjPq6ADoc=";
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
  ];

  nativeCheckInputs = [
    pytestCheckHook
    httpx
  ];

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
