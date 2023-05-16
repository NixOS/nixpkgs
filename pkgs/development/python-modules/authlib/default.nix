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
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "lepture";
    repo = "authlib";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-K6u590poZ9C3Uzi3a8k8aXMeSeRgn91e+p2PWYno3Y8=";
=======
    hash = "sha256-OYfvfPnpWE9g7L9cFXUD95B/9+OZy55ZVbmFhFgguUg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/lepture/authlib/blob/v${version}/docs/changelog.rst";
=======
    changelog = "https://github.com/lepture/authlib/releases/tag/v${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.bsd3;
    maintainers = with maintainers; [ flokli ];
  };
}
