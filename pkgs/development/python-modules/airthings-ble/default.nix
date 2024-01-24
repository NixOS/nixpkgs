{ lib
, async-interrupt
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
  version = "0.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "vincegio";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-T+KtB6kPrLahI73W/Bb3A9ws91v4n1EtURgm3RcLzW8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "-v -Wdefault --cov=airthings_ble --cov-report=term-missing:skip-covered" ""
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    async-interrupt
    bleak
    bleak-retry-connector
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
