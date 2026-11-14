{
  lib,
  aiohttp,
  bleak-retry-connector,
  bleak,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  poetry-core,
  pyopenssl,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyswitchbot";
  version = "3.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sblibs";
    repo = "pySwitchbot";
    tag = finalAttrs.version;
    hash = "sha256-DjB7vYFwZNfvz0HQRiPBA7et1ohAflBvbDogL3ns8jA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    bleak
    bleak-retry-connector
    cryptography
    pyopenssl
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "switchbot" ];

  meta = {
    description = "Python library to control Switchbot IoT devices";
    homepage = "https://github.com/sblibs/pySwitchbot";
    changelog = "https://github.com/sblibs/pySwitchbot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
})
