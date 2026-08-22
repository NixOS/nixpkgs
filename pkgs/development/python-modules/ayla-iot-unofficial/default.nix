{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  setuptools,
  ujson,
}:

buildPythonPackage (finalAttrs: {
  pname = "ayla-iot-unofficial";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rewardone";
    repo = "ayla-iot-unofficial";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N13xC2riZ31J1DzwP9vFXvz69w1DVbwEtbFubX5dvwQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    requests
    ujson
  ];

  pythonImportsCheck = [ "ayla_iot_unofficial" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/ayla_iot_unofficial.py" ];

  # tests interact with the actual API
  doCheck = false;

  meta = {
    changelog = "https://github.com/rewardone/ayla-iot-unofficial/releases/tag/${finalAttrs.src.tag}";
    description = "Unofficial python library for interacting with the Ayla IoT API";
    homepage = "https://github.com/rewardone/ayla-iot-unofficial";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
