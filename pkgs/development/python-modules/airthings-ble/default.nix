{ lib
, async-interrupt
, async-timeout
, bleak
, bleak-retry-connector
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "airthings-ble";
  version = "0.7.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "vincegio";
    repo = "airthings-ble";
    rev = "refs/tags/${version}";
    hash = "sha256-BeOrGRVxvfQR1xqIpOp4tOTvlqTKCZHUjVKDqVjVnYM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "-v -Wdefault --cov=airthings_ble --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    async-interrupt
    bleak
    bleak-retry-connector
  ]  ++ lib.optionals (pythonOlder "3.11") [
    async-timeout
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "airthings_ble"
  ];

  meta = with lib; {
    description = "Library for Airthings BLE devices";
    homepage = "https://github.com/vincegio/airthings-ble";
    changelog = "https://github.com/vincegio/airthings-ble/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
