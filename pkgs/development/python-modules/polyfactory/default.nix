{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

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

  enabledTestPaths = [
    "tests/test_msgspec_factory.py"
  ];

  disabledTests = [
    # Unsupported type: LiteralAlias
    "test_type_alias"
    # Unsupported type: 'JsonValue' on field '' from class RecursiveTypeModelFactory.
    "test_recursive_type_annotation"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # AttributeError: 'Foo' object has no attribute 'set_field'
    "test_other_basic_types"

    # KeyError: 'foo_field'
    "test_with_nested_struct"

    # AttributeError: 'Foo' object has no attribute 'unset'
    "test_msgspec_types"

    # Failed: DID NOT RAISE <class 'polyfactory.exceptions.ParameterException'>
    "test_datetime_constraints"

    # assert <msgspec._core.Field object at 0x7ffff34794c0> == 10
    "test_use_default_with_callable_default"
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
