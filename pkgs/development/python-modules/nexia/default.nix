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
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "nexia";
    tag = version;
    hash = "sha256-TY4aJnqw3+n30YyPwvh8hwsxibmOBFcRHnQxMkiRgz4=";
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
