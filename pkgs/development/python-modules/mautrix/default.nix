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
, sqlalchemy
, asyncpg
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.19.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "python";
    rev = "v${version}";
    hash = "sha256-7nvy2/DUS2BkcyQUUG8+aT/JHcPu141e5YWOiccS6cU=";
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
    sqlalchemy
    asyncpg
  ] ++ passthru.optional-dependencies.encryption;

  SQLALCHEMY_SILENCE_UBER_WARNING = 1;

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
