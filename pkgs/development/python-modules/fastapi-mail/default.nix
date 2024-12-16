{
  lib,
  aiosmtplib,
  blinker,
  buildPythonPackage,
  email-validator,
  fakeredis,
  fetchFromGitHub,
  httpx,
  jinja2,
  poetry-core,
  pydantic-settings,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  redis,
  starlette,
}:

buildPythonPackage rec {
  pname = "fastapi-mail";
  version = "1.4.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sabuhish";
    repo = "fastapi-mail";
    rev = "refs/tags/${version}";
    hash = "sha256-QypW7yE5jBkS1Q4XPIOktWnCmCXGoUzZF/SdWmFsPX8=";
  };

  pythonRelaxDeps = [
    "aiosmtplib"
    "pydantic"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aiosmtplib
    blinker
    email-validator
    fakeredis
    jinja2
    pydantic
    pydantic-settings
    starlette
  ];

  optional-dependencies = {
    httpx = [ httpx ];
    redis = [ redis ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require access to /etc/resolv.conf
    "test_default_checker"
    "test_redis_checker"
  ];

  pythonImportsCheck = [ "fastapi_mail" ];

  meta = with lib; {
    description = "Module for sending emails and attachments";
    homepage = "https://github.com/sabuhish/fastapi-mail";
    changelog = "https://github.com/sabuhish/fastapi-mail/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
