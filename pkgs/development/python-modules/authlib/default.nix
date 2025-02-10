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
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "authlib";
    tag = "v${version}";
    hash = "sha256-1Iygc35+Vc1zyn8rjubnSLmpvjckY4TRKOtf2bkrkdI=";
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

  preCheck = ''
    # httpx 0.28.0+ requires SSL_CERT_FILE or SSL_CERT_DIR
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';

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
    changelog = "https://github.com/lepture/authlib/blob/v${version}/docs/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ flokli ];
  };
}
