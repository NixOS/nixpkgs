{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
}:

buildPythonPackage rec {
  pname = "pysmartthings";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "andrewsayre";
    repo = "pysmartthings";
    rev = "v${version}";
    hash = "sha256-hVEZA7CwkgsptoPyWuhog+oi2WIsUYZsPko4RhfuApc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "pysmartthings" ];

  meta = with lib; {
    description = "Python library for interacting with the SmartThings cloud API";
    homepage = "https://github.com/andrewsayre/pysmartthings";
    changelog = "https://github.com/andrewsayre/pysmartthings/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
