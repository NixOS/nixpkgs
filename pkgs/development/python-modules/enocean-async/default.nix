{
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  serialx,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "enocean-async";
  version = "0.13.5";
  pyproject = true;

  disabled = pythonOlder "3.14";

  src = fetchFromGitHub {
    owner = "henningkerstan";
    repo = "enocean-async";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D0ocHDr75cwPK7Ci3sq+I1bk/152m2dL+jXgGBNQjMc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    serialx
  ];

  pythonImportsCheck = [ "enocean_async" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/henningkerstan/enocean-async/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Async implementation of the EnOcean Serial Protocol Version 3";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
