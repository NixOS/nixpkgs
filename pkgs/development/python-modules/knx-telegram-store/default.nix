{
  aiosqlite,
  asyncpg,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage (finalAttrs: {
  pname = "knx-telegram-store";
  version = "0.4.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = "knx-telegram-store";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t4Bmm5n9+XSBiR2Rvm6UKAKweH9fQuZwaNqG1W2q3Co=";
  };

  build-system = [
    setuptools
  ];

  optional-dependencies = {
    postgres = [
      asyncpg
      sqlalchemy
    ];
    sqlite = [
      aiosqlite
      sqlalchemy
    ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.sqlite;

  pythonImportsCheck = [
    "knx_telegram_store"
  ];

  meta = {
    description = "Standalone, host-agnostic Python library for KNX telegram persistence";
    homepage = "https://github.com/XKNX/knx-telegram-store";
    changelog = "https://github.com/XKNX/knx-telegram-store/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
