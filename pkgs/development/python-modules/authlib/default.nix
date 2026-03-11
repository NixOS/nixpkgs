{
  lib,
  buildPythonPackage,
  cachelib,
  cryptography,
  fetchFromGitHub,
  flask,
  flask-sqlalchemy,
  httpx,
  mock,
  pytest-asyncio,
  pytestCheckHook,
  python-multipart,
  pythonOlder,
  requests,
  setuptools,
  starlette,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "authlib";
  version = "1.6.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "authlib";
    tag = "v${version}";
    hash = "sha256-9H9DF3LmxzUv0M0fxYh6FLtdAA9FgRklceMlGdjlp+g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
  ];

  nativeCheckInputs = [
    cachelib
    flask
    flask-sqlalchemy
    httpx
    mock
    pytest-asyncio
    pytestCheckHook
    python-multipart
    requests
    starlette
    werkzeug
  ];

  pythonImportsCheck = [ "authlib" ];

  disabledTestPaths = [
    # Django tests require a running instance
    "tests/django/"
    "tests/clients/test_django/"
    # Unsupported encryption algorithm
    "tests/jose/test_chacha20.py"
  ];

  meta = {
    description = "Library for building OAuth and OpenID Connect servers";
    homepage = "https://github.com/lepture/authlib";
    changelog = "https://github.com/lepture/authlib/blob/${src.tag}/docs/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
