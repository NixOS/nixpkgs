{
  lib,
  buildPythonPackage,
  email-validator,
  fastapi,
  fetchFromGitHub,
  httpx,
  oauthlib,
  poetry-core,
  pydantic,
  pyjwt,
  pytest-cov-stub,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastapi-sso";
  version = "0.21.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tomasvotava";
    repo = "fastapi-sso";
    tag = finalAttrs.version;
    hash = "sha256-/5YuHLDYLnVQc/34OdlRTCJAVL2z6MZV8stSV/tpte4=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    fastapi
    httpx
    oauthlib
    pydantic
    pyjwt
  ]
  ++ pydantic.optional-dependencies.email;

  nativeCheckInputs = [
    email-validator
    pytest-asyncio
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fastapi_sso" ];

  meta = {
    description = "FastAPI plugin to enable SSO to most common providers (such as Facebook login, Google login and login via Microsoft Office 365 Account";
    homepage = "https://github.com/tomasvotava/fastapi-sso";
    changelog = "https://github.com/tomasvotava/fastapi-sso/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
