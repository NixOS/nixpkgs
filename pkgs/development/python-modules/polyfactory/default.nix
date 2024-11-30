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
  version = "2.18.1";
  pyproject = true;

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-F8nbGK/k+4192OW6KW5p2g/PfQ87Y9GEDrENE1rtWq0=";
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
