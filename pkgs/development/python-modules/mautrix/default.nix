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
, asyncpg
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.20.3";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "python";
    rev = "refs/tags/v${version}";
    hash = "sha256-7ZSPxKRLAgwC1ECxa1eOTH60cMJXs1iv2PE2Vq9f0co=";
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
    asyncpg
  ] ++ passthru.optional-dependencies.encryption;

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
