{ lib
, bleak
, bleak-retry-connector
, boto3
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pyopenssl
, pythonOlder
, pytestCheckHook
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "pyswitchbot";
  version = "0.44.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pySwitchbot";
    rev = "refs/tags/${version}";
    hash = "sha256-i3OQ2QOBMaiNTyq44wbnHZ2iqAXEYB16NWKWzOza1Jo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
    boto3
    cryptography
    pyopenssl
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # mismatch in expected data structure
    "test_parse_advertisement_data_curtain"
  ];

  pythonImportsCheck = [
    "switchbot"
  ];

  meta = with lib; {
    description = "Python library to control Switchbot IoT devices";
    homepage = "https://github.com/Danielhiversen/pySwitchbot";
    changelog = "https://github.com/Danielhiversen/pySwitchbot/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
