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
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "gardena-bluetooth";
    tag = finalAttrs.version;
    hash = "sha256-QIjCIfsD/YOPfbmHoerynb5iqne0MBlK0y89cc7gR1U=";
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
