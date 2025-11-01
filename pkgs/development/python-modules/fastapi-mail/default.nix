{
  lib,
  aiosmtplib,
  blinker,
  buildPythonPackage,
  cryptography,
  email-validator,
  fakeredis,
  fastapi,
  fetchFromGitHub,
  flake8,
  httpx,
  isort,
  jinja2,
  mkdocs-material,
  poetry-core,
  pydantic-settings,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  redis,
  regex,
  starlette,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "fastapi-mail";
  version = "1.5.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sabuhish";
    repo = "fastapi-mail";
    tag = version;
    hash = "sha256-C2hjnbTNKtuonY8TZzrx1v0QOt7fgnteEOB3E2kCwhc=";
  };

  pythonRelaxDeps = [
    "aiosmtplib"
    "cryptography"
    "email-validator"
    "fastapi"
    "isort"
    "pydantic"
    "regex"
    "uvicorn"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aiosmtplib
    blinker
    cryptography
    email-validator
    fakeredis
    fastapi
    flake8
    isort
    jinja2
    mkdocs-material
    pydantic
    pydantic-settings
    regex
    starlette
    uvicorn
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
