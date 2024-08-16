{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pythonOlder,
  iso4217,
  pyserial,
  pyserial-asyncio-fast,
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "aioraven";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "cottsay";
    repo = "aioraven";
    rev = "refs/tags/${version}";
    hash = "sha256-ux2jeXkh8YsJ6mItXOx40pp0Tc+aJXMV7ZqyZg+iy2c=";
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

  meta = with lib; {
    description = "Module for communication with RAVEn devices";
    homepage = "https://github.com/cottsay/aioraven";
    changelog = "https://github.com/cottsay/aioraven/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
