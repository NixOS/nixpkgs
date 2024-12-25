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
  version = "0.55.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    rev = "refs/tags/${version}";
    hash = "sha256-On/FKfdiqx28MCx1kCcstb90iT1e20c84hHxdQSIark=";
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
    changelog = "https://github.com/Danielhiversen/pySwitchbot/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
