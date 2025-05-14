{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  # deps
  setuptools,
  aiohttp,
  attrs,
  yarl,
  # optional deps
  python-magic,
  python-olm,
  unpaddedbase64,
  pycryptodome,
  # check deps
  pytestCheckHook,
  pytest-asyncio,
  aiosqlite,
  asyncpg,
  ruamel-yaml,

  withOlm ? false,
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.20.7";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "python";
    tag = "v${version}";
    hash = "sha256-tOX/KQrECeEV3/0q3tpO4brUdalmw6IincF6pHzsEE8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    attrs
    yarl
  ] ++ lib.optionals withOlm optional-dependencies.encryption;

  optional-dependencies = {
    detect_mimetype = [ python-magic ];
    encryption = [
      python-olm
      unpaddedbase64
      pycryptodome
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    aiosqlite
    asyncpg
    ruamel-yaml
  ];

  disabledTestPaths = lib.optionals (!withOlm) [ "mautrix/crypto/" ];

  pythonImportsCheck = [ "mautrix" ];

  meta = with lib; {
    description = "Asyncio Matrix framework";
    homepage = "https://github.com/tulir/mautrix-python";
    changelog = "https://github.com/mautrix/python/releases/tag/v${version}";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      nyanloutre
      ma27
      sumnerevans
      nickcao
    ];
  };
}
