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
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fastapi-sso";
<<<<<<< HEAD
  version = "0.19.0";
=======
  version = "0.18.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "tomasvotava";
    repo = "fastapi-sso";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-ve1xeJjAfE6b5NBJJZuDUdE58RjDmIq3KI3xC5ScCco=";
=======
    hash = "sha256-591+7Jjg3Pb0qXZsj4tEk8lHqxAzWrs5GO92jFJ4Qmo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "FastAPI plugin to enable SSO to most common providers (such as Facebook login, Google login and login via Microsoft Office 365 Account";
    homepage = "https://github.com/tomasvotava/fastapi-sso";
    changelog = "https://github.com/tomasvotava/fastapi-sso/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "FastAPI plugin to enable SSO to most common providers (such as Facebook login, Google login and login via Microsoft Office 365 Account";
    homepage = "https://github.com/tomasvotava/fastapi-sso";
    changelog = "https://github.com/tomasvotava/fastapi-sso/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
