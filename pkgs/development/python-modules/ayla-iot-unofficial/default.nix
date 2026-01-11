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

buildPythonPackage rec {
  pname = "ayla-iot-unofficial";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rewardone";
    repo = "ayla-iot-unofficial";
    tag = "v${version}";
    hash = "sha256-/Js2XMhGe4zPAjpeH2ON4377TAPaWPvA8+HEliYKxlw=";
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
    changelog = "https://github.com/rewardone/ayla-iot-unofficial/releases/tag/${src.tag}";
    description = "Unofficial python library for interacting with the Ayla IoT API";
    homepage = "https://github.com/rewardone/ayla-iot-unofficial";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
