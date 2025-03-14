{
  lib,
  async-timeout,
  bleak-retry-connector,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ld2410-ble";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "930913";
    repo = "ld2410-ble";
    tag = "v${version}";
    hash = "sha256-wQnE2hNT0UOnPJbHq1eayIO8g0XRZvEH6V19DL6RqoA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    async-timeout
    bleak
    bleak-retry-connector
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ld2410_ble" ];

  meta = with lib; {
    description = "Library for the LD2410B modules from HiLinks";
    homepage = "https://github.com/930913/ld2410-ble";
    changelog = "https://github.com/930913/ld2410-ble/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
