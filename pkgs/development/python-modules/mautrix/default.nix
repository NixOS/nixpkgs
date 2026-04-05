{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # deps
  setuptools,
  aiohttp,
  attrs,
  yarl,
  # optional deps
  base58,
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
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "python";
    tag = "v${version}";
    hash = "sha256-4nEjKIWzXd0e/cLL4py9SS+/YIcGHq2f+cCTEY2ENmE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    attrs
    yarl
  ]
  ++ lib.optionals withOlm optional-dependencies.encryption;

  optional-dependencies = {
    detect_mimetype = [ python-magic ];
    encryption = [
      base58
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

  meta = {
    description = "Asyncio Matrix framework";
    homepage = "https://github.com/tulir/mautrix-python";
    changelog = "https://github.com/mautrix/python/releases/tag/${src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      nyanloutre
      sumnerevans
      nickcao
    ];
  };
}
