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
  version = "2.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "litestar-org";
    repo = "polyfactory";
    tag = "v${version}";
    hash = "sha256-0VsH2J+vEk3cF7AYvirnXPupSLE2EGrp9FF+/EOWAbw=";
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

  disabledTests = [
    # Unsupported type: LiteralAlias
    "test_type_alias"
  ];

  pythonImportsCheck = [ "polyfactory" ];

  meta = {
    homepage = "https://polyfactory.litestar.dev/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    changelog = "https://github.com/litestar-org/polyfactory/releases/tag/v${version}";
    description = "Simple and powerful factories for mock data generation";
    license = lib.licenses.mit;
  };
}
