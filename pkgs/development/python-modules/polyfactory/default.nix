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
  beanie,
}:

buildPythonPackage rec {
  pname = "polyfactory";
  version = "2.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "litestar-org";
    repo = "polyfactory";
    tag = "v${version}";
    hash = "sha256-CoD0DIo3s7pzD9kobDPxLaxK8LZhqkXCIpzyR4fVJrg=";
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
    beanie
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTests = [
    # Unsupported type: LiteralAlias
    "test_type_alias"
  ];

  pythonImporeCheck = [ "polyfactory" ];

  meta = {
    homepage = "https://polyfactory.litestar.dev/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    changelog = "https://github.com/litestar-org/polyfactory/releases/tag/${src.tag}";
    description = "Simple and powerful factories for mock data generation";
    license = lib.licenses.mit;
  };
}
