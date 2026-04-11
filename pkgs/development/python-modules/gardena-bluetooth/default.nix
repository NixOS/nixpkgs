{
  lib,
  asyncclick,
  bleak-retry-connector,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  tzlocal,
}:

buildPythonPackage (finalAttrs: {
  pname = "gardena-bluetooth";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "gardena-bluetooth";
    tag = finalAttrs.version;
    hash = "sha256-1G7d8sILpgDm9rwNIV20C14xmzCKrozGPctXn2hBBIQ=";
  };

  build-system = [ setuptools ];

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
