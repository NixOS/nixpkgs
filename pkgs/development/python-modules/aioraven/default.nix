{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  iso4217,
  pyserial,
  pyserial-asyncio-fast,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "aioraven";
  version = "0.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cottsay";
    repo = "aioraven";
    tag = version;
    hash = "sha256-rGqaDJtpdDWd8fxdfwU+rmgwEzZyYHfbiZxUlWoH2ks=";
  };

  build-system = [ setuptools ];

  dependencies = [
    iso4217
    pyserial
    pyserial-asyncio-fast
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioraven" ];

  meta = {
    description = "Module for communication with RAVEn devices";
    homepage = "https://github.com/cottsay/aioraven";
    changelog = "https://github.com/cottsay/aioraven/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
