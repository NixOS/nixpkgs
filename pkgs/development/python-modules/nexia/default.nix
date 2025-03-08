{
  lib,
  aioresponses,
  buildPythonPackage,
  orjson,
  fetchFromGitHub,
  propcache,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  aiohttp,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nexia";
  version = "2.2.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "nexia";
    tag = version;
    hash = "sha256-rh2ZLJIzLMxjGvs6cKT2m+1HGBhUSV8KParsC6/JSlY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
    propcache
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nexia" ];

  meta = with lib; {
    description = "Python module for Nexia thermostats";
    homepage = "https://github.com/bdraco/nexia";
    changelog = "https://github.com/bdraco/nexia/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
