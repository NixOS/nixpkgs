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
  version = "0.12.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = "knx-telegram-store";
    tag = "v${finalAttrs.version}";
    hash = "sha256-otHKGgWjo8j6jlWlD7ojh/3LGlR41hQQGueCxvocCM4=";
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
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

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
