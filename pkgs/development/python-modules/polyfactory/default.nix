{
  buildPythonPackage,
  lib,
  fetchPypi,
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
}:

buildPythonPackage rec {
  pname = "polyfactory";
  version = "2.18.0";
  pyproject = true;

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-BNi01JhuQGzUwWzAHou3Rwg4QtV6XA26Y6Ie5e91umY=";
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
