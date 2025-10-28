{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  yarl,
}:

buildPythonPackage rec {
  pname = "ha-silabs-firmware-client";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "ha-silabs-firmware-client";
    tag = "v${version}";
    hash = "sha256-Kip9JL9tuF7OI22elN0w2Z7Xjdaayboo8LThp4FAets=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning<3"' "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

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
    changelog = "https://github.com/home-assistant-libs/ha-silabs-firmware-client/releases/tag/${src.tag}";
    description = "Home Assistant client for firmwares released with silabs-firmware-builder";
    homepage = "https://github.com/home-assistant-libs/ha-silabs-firmware-client";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
