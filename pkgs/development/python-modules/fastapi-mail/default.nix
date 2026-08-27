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
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  redis,
  regex,
  starlette,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastapi-mail";
  version = "1.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sabuhish";
    repo = "fastapi-mail";
    tag = finalAttrs.version;
    hash = "sha256-7Of7PSfY5lFbuxqBM5IyCnOa1CwbOijruSSrRylz3S8=";
  };

  pythonRelaxDeps = [ "cryptography" ];

  build-system = [ poetry-core ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    aiosmtplib
    blinker
    cryptography
    email-validator
    fakeredis
    httpx
    jinja2
    pydantic
    pydantic-settings
    regex
    starlette
  ];

  optional-dependencies = {
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

  meta = {
    description = "Module for sending emails and attachments";
    homepage = "https://github.com/sabuhish/fastapi-mail";
    changelog = "https://github.com/sabuhish/fastapi-mail/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
