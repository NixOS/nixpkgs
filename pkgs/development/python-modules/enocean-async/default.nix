{
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  lib,
  pyserial-asyncio-fast,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "enocean-async";
  version = "0.4.2";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "henningkerstan";
    repo = "enocean-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VBBZwNPBgJ9rXUaAVtRzgdebeDtfJCt7R1zOu3Eom80=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyserial-asyncio-fast
  ];

  pythonImportsCheck = [ "enocean_async" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # tests have broken imports, fixed in 0.12.4
    "tests/test_eep.py"
  ];

  meta = {
    changelog = "https://github.com/henningkerstan/enocean-async/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Async implementation of the EnOcean Serial Protocol Version 3";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
