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
  pytest,
  pytest-asyncio,
  pytest-httpx,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "beanhub-cli";
  version = "2.1.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "beanhub-cli";
    tag = version;
    hash = "sha256-mGLg6Kgur2LAcujFzO/rkSPAC2t3wR5CO2AeOO0+bFI=";
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
    pydantic-settings
    pyyaml
    rich
    starlette-wtf
    uvicorn
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-httpx
    pytest-mock
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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
