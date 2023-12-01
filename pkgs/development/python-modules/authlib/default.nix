{ lib
, buildPythonPackage
, cachelib
, cryptography
, fetchFromGitHub
, flask
, flask-sqlalchemy
, httpx
, mock
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, requests
, starlette
, werkzeug
}:

buildPythonPackage rec {
  pname = "authlib";
  version = "1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "authlib";
    rev = "refs/tags/v${version}";
    hash = "sha256-K6u590poZ9C3Uzi3a8k8aXMeSeRgn91e+p2PWYno3Y8=";
  };

  propagatedBuildInputs = [
    cryptography
    requests
  ];

  nativeCheckInputs = [
    cachelib
    flask
    flask-sqlalchemy
    httpx
    mock
    pytest-asyncio
    pytestCheckHook
    starlette
    werkzeug
  ];

  pythonImportsCheck = [
    "authlib"
  ];

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
