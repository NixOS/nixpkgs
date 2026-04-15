{
  lib,
  aiohttp,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pyopenssl,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyswitchbot";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    tag = finalAttrs.version;
    hash = "sha256-1DJ7mo1L75PPoVivngJPdbEWFTF36KLShkr3V1/rLDY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    bleak
    bleak-retry-connector
    cryptography
    pyopenssl
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "switchbot" ];

  meta = {
    description = "Python library to control Switchbot IoT devices";
    homepage = "https://github.com/Danielhiversen/pySwitchbot";
    changelog = "https://github.com/Danielhiversen/pySwitchbot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
})
