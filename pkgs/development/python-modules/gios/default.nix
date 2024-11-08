{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  dacite,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-error-for-skips,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "gios";
  version = "5.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "gios";
    rev = "refs/tags/${version}";
    hash = "sha256-J+LCu7wMuc3dYghvkKq58GcBAa76X5IPUWe7qCQwjjI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    dacite
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # Test requires network access
    "test_invalid_station_id"
  ];

  pythonImportsCheck = [ "gios" ];

  meta = with lib; {
    description = "Python client for getting air quality data from GIOS";
    homepage = "https://github.com/bieniu/gios";
    changelog = "https://github.com/bieniu/gios/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
