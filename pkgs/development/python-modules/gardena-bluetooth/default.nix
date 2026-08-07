{
  lib,
  asyncclick,
  bleak-retry-connector,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytest-asyncio,
  pytestCheckHook,
  tzlocal,
  uv-dynamic-versioning,
}:

buildPythonPackage (finalAttrs: {
  pname = "gardena-bluetooth";
  version = "2.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "gardena-bluetooth";
    tag = finalAttrs.version;
    hash = "sha256-N8c7P7/su4hqZXQlkdUt1u+50ZXBDtdok5n5RWE9w4E=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    bleak
    bleak-retry-connector
    tzlocal
  ];

  optional-dependencies = {
    cli = [ asyncclick ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "gardena_bluetooth" ];

  meta = {
    description = "Module for interacting with Gardena Bluetooth";
    homepage = "https://github.com/elupus/gardena-bluetooth";
    changelog = "https://github.com/elupus/gardena-bluetooth/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
