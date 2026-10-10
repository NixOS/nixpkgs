{
  lib,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "besen";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moryoav";
    repo = "besen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rn4afXYjb+0G2ILfwJPIQ+Vs0DLWmKPSR2OD8UfkL8I=";
  };

  build-system = [ setuptools ];

  dependencies = [ bleak-retry-connector ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  # The other tests are for the bundled Home Assistant integration
  pytestFlags = [
    "tests/test_client.py"
    "tests/test_models.py"
    "tests/test_protocol.py"
  ];

  pythonImportsCheck = [ "besen" ];

  meta = {
    description = "Async Python client for Besen EV chargers over BLE";
    homepage = "https://github.com/moryoav/besen";
    changelog = "https://github.com/moryoav/besen/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
