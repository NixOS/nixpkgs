{
  lib,
  bleak,
  bleak-retry-connector,
  boto3,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pyopenssl,
  pythonOlder,
  pytest-asyncio,
  pytestCheckHook,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyswitchbot";
  version = "0.67.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    tag = version;
    hash = "sha256-e2bzmJAwJ6BbqP3R0FmTG1UR6TsPggXJlSkO3wdPWQY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
    boto3
    cryptography
    pyopenssl
    requests
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "switchbot" ];

  meta = with lib; {
    description = "Python library to control Switchbot IoT devices";
    homepage = "https://github.com/Danielhiversen/pySwitchbot";
    changelog = "https://github.com/Danielhiversen/pySwitchbot/releases/tag/${src.tag}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
