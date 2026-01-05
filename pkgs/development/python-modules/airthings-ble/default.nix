{
  lib,
  async-interrupt,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  cbor2,
  fetchFromGitHub,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "airthings-ble";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vincegio";
    repo = "airthings-ble";
    tag = version;
    hash = "sha256-y6vpkq3u5JKImwxevMupUVVAclUcsyrqxoIOYRK0YGQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    async-interrupt
    bleak-retry-connector
    cbor2
  ]
  ++ lib.optionals (pythonOlder "3.14") [
    bleak
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "airthings_ble" ];

  meta = with lib; {
    description = "Library for Airthings BLE devices";
    homepage = "https://github.com/vincegio/airthings-ble";
    changelog = "https://github.com/vincegio/airthings-ble/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
