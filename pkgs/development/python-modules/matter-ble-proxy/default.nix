{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  aiohttp,
  bleak,
  pytest-asyncio,
  pytest-aiohttp,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "matter-ble-proxy";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "matter-js";
    repo = "matterjs-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c/jhQfenRgE0qHisGM1TOtqWjDy/RcwGa04RE0FzR/U=";
  };

  sourceRoot = "${finalAttrs.src.name}/python_ble_proxy";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bleak
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "matter_ble_proxy" ];

  __structuredAttrs = true;

  meta = {
    description = "Client library for the OHF Matter Server BLE proxy protocol";
    homepage = "https://github.com/matter-js/matterjs-server/tree/main/python_ble_proxy";
    changelog = "https://github.com/matter-js/matterjs-server/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "matter-ble-proxy";
  };
})
