{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  aiosqlite,
  email-validator,
  faker,
  hypothesis,
  msgspec,
  pydantic,
  pymongo,
  sqlalchemy,
  typing-extensions,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "polyfactory";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "litestar-org";
    repo = "polyfactory";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J/CHf85jomybMp2U9l5kbD5q0MtYlY9hZkjxjS2jXvg=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiosqlite
    email-validator
    faker
    hypothesis
    msgspec
    pydantic
    pymongo
    sqlalchemy
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTestPaths = [
    # Requires unpackaged 'beanie'
    "tests/test_beanie_factory.py"
  ];

  disabledTests = [
    # Unsupported type: LiteralAlias
    "test_type_alias"
    # Unsupported type: 'JsonValue' on field '' from class RecursiveTypeModelFactory.
    "test_recursive_type_annotation"
  ];

  pythonImportsCheck = [ "polyfactory" ];

  meta = {
    homepage = "https://polyfactory.litestar.dev/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    changelog = "https://github.com/litestar-org/polyfactory/releases/tag/${finalAttrs.src.tag}";
    description = "Simple and powerful factories for mock data generation";
    license = lib.licenses.mit;
  };
})
