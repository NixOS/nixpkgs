{
  lib,
  aiohttp,
  aiosseclient,
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
  yarl,
}:

buildPythonPackage rec {
  pname = "pysmartthings";
  version = "2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "pySmartThings";
    repo = "pysmartthings";
    rev = "v${version}";
    hash = "sha256-t52XRDHirM0e+MUvG8/54LQVZcXe7Nsl++2kSNbIfg8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiosseclient
    mashumaro
    orjson
    yarl
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
    changelog = "https://github.com/andrewsayre/pysmartthings/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
