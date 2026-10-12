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
  version = "0.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moryoav";
    repo = "besen";
    tag = "library-v${finalAttrs.version}";
    hash = "sha256-qXvp0tP+KoSdm+Hbq+TAFodvEJK8M0x1YrZiMYv5CPY=";
  };

  build-system = [ setuptools ];

  dependencies = [ bleak-retry-connector ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    # specific to the custom component tests
    rm tests/conftest.py
  '';

  enabledTestPaths = [ "tests/library" ];

  pythonImportsCheck = [ "besen" ];

  meta = {
    description = "Async Python client for Besen EV chargers over BLE";
    homepage = "https://github.com/moryoav/besen";
    changelog = "https://github.com/moryoav/besen/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
