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
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    tag = finalAttrs.version;
    hash = "sha256-sJM7keXUdDC/qaeZSP8DAVzy/15/ilz/53CZE+KgB9Y=";
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
    homepage = "https://github.com/Danielhiversen/pySwitchbot";
    changelog = "https://github.com/Danielhiversen/pySwitchbot/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
})
