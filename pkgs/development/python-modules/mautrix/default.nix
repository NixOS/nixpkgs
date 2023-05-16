{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
  # deps
, aiohttp
, attrs
, yarl
  # optional deps
, python-magic
, python-olm
, unpaddedbase64
, pycryptodome
  # check deps
, pytestCheckHook
, pytest-asyncio
, aiosqlite
<<<<<<< HEAD
=======
, sqlalchemy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, asyncpg
}:

buildPythonPackage rec {
  pname = "mautrix";
<<<<<<< HEAD
  version = "0.20.1";
  format = "setuptools";

  disabled = pythonOlder "3.9";
=======
  version = "0.19.13";
  format = "setuptools";

  disabled = pythonOlder "3.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "python";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-Byvwg6WW4b8kRWJkl6DG2Ioz4HYDaJyVEV98tS/ybXQ=";
=======
    hash = "sha256-nmsYe/iDKW4dUSuxSoUz2NpAGLPOTzrBNy6AwYMVs8k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    aiohttp
    attrs
    yarl
  ];

  passthru.optional-dependencies = {
    detect_mimetype = [
      python-magic
    ];
    encryption = [
      python-olm
      unpaddedbase64
      pycryptodome
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    pytest-asyncio
    aiosqlite
<<<<<<< HEAD
    asyncpg
  ] ++ passthru.optional-dependencies.encryption;

=======
    sqlalchemy
    asyncpg
  ] ++ passthru.optional-dependencies.encryption;

  SQLALCHEMY_SILENCE_UBER_WARNING = 1;

  disabledTestPaths = [
    # sqlalchemy 2 unsupported
    "mautrix/client/state_store/tests/store_test.py"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pythonImportsCheck = [
    "mautrix"
  ];

  meta = with lib; {
    description = "Asyncio Matrix framework";
    homepage = "https://github.com/tulir/mautrix-python";
    changelog = "https://github.com/mautrix/python/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyanloutre ma27 sumnerevans nickcao ];
  };
}
