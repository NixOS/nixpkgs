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
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moryoav";
    repo = "py-besen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wj525BEtN/1nG7hKzGBQB1v+npgPg4FSTPvWNMN5mFw=";
  };

  build-system = [ setuptools ];

  dependencies = [ bleak-retry-connector ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "besen" ];

  meta = {
    description = "Async Python client for Besen EV chargers over BLE";
    homepage = "https://github.com/moryoav/py-besen";
    changelog = "https://github.com/moryoav/py-besen/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
