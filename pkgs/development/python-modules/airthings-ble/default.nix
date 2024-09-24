{
  lib,
  async-interrupt,
  async-timeout,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "airthings-ble";
  version = "0.9.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "vincegio";
    repo = "airthings-ble";
    rev = "refs/tags/${version}";
    hash = "sha256-pk/S0ufzirH4Xny0+nFVH366d0imqB2K6NvkGP7jAU4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "-v -Wdefault --cov=airthings_ble --cov-report=term-missing:skip-covered" ""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    async-interrupt
    bleak
    bleak-retry-connector
  ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "airthings_ble" ];

  meta = with lib; {
    description = "Library for Airthings BLE devices";
    homepage = "https://github.com/vincegio/airthings-ble";
    changelog = "https://github.com/vincegio/airthings-ble/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
