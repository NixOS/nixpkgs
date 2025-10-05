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
}:

buildPythonPackage rec {
  pname = "polyfactory";
  version = "2.22.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "litestar-org";
    repo = "polyfactory";
    tag = "v${version}";
    hash = "sha256-Mm9Yj8yBaH1KQJxQJY/sbrkfL/eDpMyWd/9ThQfmzx8=";
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

  disabledTestPaths = [
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
    changelog = "https://github.com/litestar-org/polyfactory/releases/tag/${src.tag}";
    description = "Simple and powerful factories for mock data generation";
    license = lib.licenses.mit;
  };
}
