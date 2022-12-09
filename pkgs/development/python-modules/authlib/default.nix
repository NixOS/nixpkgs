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
  version = "1.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "authlib";
    rev = "refs/tags/v${version}";
    hash = "sha256-UTsQRAgmYu4BwT0WWE6XOjTYyGWZIt8bMH9qJ8KLOWA=";
  };

  propagatedBuildInputs = [
    cryptography
    requests
  ];

  checkInputs = [
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ flokli ];
  };
}
