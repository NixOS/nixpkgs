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

buildPythonPackage rec {
  pname = "pyswitchbot";
  version = "0.74.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    tag = version;
    hash = "sha256-3n6ErE17W5Gsf/Isw4o45JcDihYUHendx8MLgh8gALk=";
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
    changelog = "https://github.com/Danielhiversen/pySwitchbot/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
  };
}
