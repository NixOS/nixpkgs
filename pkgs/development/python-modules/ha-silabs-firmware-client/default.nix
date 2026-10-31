{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "ha-silabs-firmware-client";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "ha-silabs-firmware-client";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f2Lu1bzbmEfXvmefeBGC62I5mht6v84/xc5cXP8tck8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning<3"' ""
  '';

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    yarl
  ];

  pythonImportsCheck = [ "ha_silabs_firmware_client" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/home-assistant-libs/ha-silabs-firmware-client/releases/tag/${finalAttrs.src.tag}";
    description = "Home Assistant client for firmwares released with silabs-firmware-builder";
    homepage = "https://github.com/home-assistant-libs/ha-silabs-firmware-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
