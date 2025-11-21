{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-asyncio,
  aioresponses,
  aiohttp,
  pysignalr,
}:

buildPythonPackage rec {
  pname = "pyeasee";
  version = "0.8.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nordicopen";
    repo = "pyeasee";
    tag = "v${version}";
    hash = "sha256-C6aSDh5HKBozzy3FAP7cnmReMnDwW7Zj7dlAgh0Nw8E=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    aioresponses
    pytest-asyncio
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pysignalr
  ];

  meta = {
    description = "Easee EV charger API python library";
    homepage = "https://github.com/nordicopen/pyeasee";
    changelog = "https://github.com/nordicopen/pyeasee/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dandellion ];
  };
}
