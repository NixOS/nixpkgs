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
  version = "1.5.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sabuhish";
    repo = "fastapi-mail";
    tag = version;
    hash = "sha256-v8cf4GlYAdl5+iD7hJHW+FuDN/I/VygWaaZLEotDNCU=";
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
    "test_local_hostname_resolving"
  ];

  pythonImportsCheck = [ "fastapi_mail" ];

  meta = with lib; {
    description = "Module for sending emails and attachments";
    homepage = "https://github.com/sabuhish/fastapi-mail";
    changelog = "https://github.com/sabuhish/fastapi-mail/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
