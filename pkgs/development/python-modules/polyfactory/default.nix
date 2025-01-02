{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  faker,
  msgspec,
  sqlalchemy,
  aiosqlite,
  typing-extensions,
  pymongo,
  pytest-asyncio,
  pydantic,
  pytestCheckHook,
  email-validator,
  pytest-lazy-fixtures,
}:

buildPythonPackage rec {
  pname = "polyfactory";
  version = "2.18.1-unstable-2024-12-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "litestar-org";
    repo = "polyfactory";
    rev = "d6a886a4f3b33c77774e14ec190531128ce504c2";
    hash = "sha256-w13pgxVAUY/THSpwktqVgfQiGeSar9iGpzXeWv6I/vA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    faker
    typing-extensions
    hypothesis
    pydantic
    sqlalchemy
    msgspec
    pymongo
    aiosqlite
    email-validator
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImporeCheck = [ "polyfactory" ];

  meta = {
    homepage = "https://polyfactory.litestar.dev/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    changelog = "https://github.com/litestar-org/polyfactory/releases/tag/v${version}";
    description = "Simple and powerful factories for mock data generation";
    license = lib.licenses.mit;
  };
}
