{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pycryptodome,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioairq";
  version = "0.4.6";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "CorantGmbH";
    repo = "aioairq";
    tag = "v${version}";
    hash = "sha256-XlOVCDWbcdh8VjNxlEcVNttRN3mw19AXlIIQJ1II144=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pycryptodome
  ];

  # Module has no tests
  #doCheck = false;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioairq" ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_core_on_device.py"
  ];

  meta = with lib; {
    description = "Library to retrieve data from air-Q devices";
    homepage = "https://github.com/CorantGmbH/aioairq";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
