{
  lib,
  buildPythonPackage,
  cacert,
  cachelib,
  cryptography,
  fetchFromGitHub,
  flask,
  flask-sqlalchemy,
  httpx,
  mock,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  starlette,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "authlib";
  version = "1.6.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "authlib";
    tag = "v${version}";
    hash = "sha256-AzIjfUH89tYZwVnOpdSwEzaGNpedfQ50k9diKUfH+Fg=";
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

  meta = with lib; {
    description = "Library for building OAuth and OpenID Connect servers";
    homepage = "https://github.com/lepture/authlib";
    changelog = "https://github.com/lepture/authlib/blob/${src.tag}/docs/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ flokli ];
  };
}
