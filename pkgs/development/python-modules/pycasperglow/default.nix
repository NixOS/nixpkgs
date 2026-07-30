{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pycasperglow";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mikeodr";
    repo = "pycasperglow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sLjEo8GSGBtx0GDAHQZad5ePQAwzChdmBE5TU+ebuFI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pycasperglow" ];

  meta = {
    description = "Async Python library for controlling Casper Glow lights via BLE";
    homepage = "https://github.com/mikeodr/pycasperglow";
    changelog = "https://github.com/mikeodr/pycasperglow/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
