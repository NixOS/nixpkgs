{
  lib,
  aiosmtplib,
  blinker,
  buildPythonPackage,
  cryptography,
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
  redis,
  regex,
  starlette,
}:

buildPythonPackage rec {
  pname = "fastapi-mail";
  version = "1.5.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sabuhish";
    repo = "fastapi-mail";
    tag = version;
    hash = "sha256-xxArFytTJKLTlBjR3T+c1OTpK3vSgIrpRJqQEcFs4J4=";
  };

  pythonRelaxDeps = [
    "aiosmtplib"
    "cryptography"
    "email-validator"
    "pydantic"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aiosmtplib
    blinker
    cryptography
    email-validator
    fakeredis
    jinja2
    pydantic
    pydantic-settings
    regex
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
    changelog = "https://github.com/sabuhish/fastapi-mail/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
