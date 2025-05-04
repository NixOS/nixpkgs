{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  flit,
  pydantic,
  motor,
  click,
  toml,
  lazy-model,
  typing-extensions,
  pytestCheckHook,
  pydantic-settings,
  pytest-cov-stub,
  asgi-lifespan,
  email-validator,
  httpx,
fastapi,
pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "beanie";
  version = "1.29.0";
  pyproject = true;

  build-system = [
    flit
  ];

  src = fetchFromGitHub {
    owner = "BeanieODM";
    repo = "beanie";
    tag = version;
    hash = "sha256-Q/OlBWC2cY59VuzFtuy+Y+nhqptIttX+kPZFFULKD28=";
  };

  dependencies = [
    pydantic
    motor
    click
    toml
    lazy-model
    typing-extensions
    pydantic-settings
    asgi-lifespan
    email-validator
    httpx
    fastapi
  ];

  pythonRelaxDeps = [
    "lazy-model"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-asyncio
  ];

  meta = {
    description = "Asynchronous Python ODM for MongoDB";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/BeanieODM/beanie/releases/tag/${version}";
    homepage = "https://beanie-odm.dev/";
    license = lib.licenses.asl20;
  };
}
