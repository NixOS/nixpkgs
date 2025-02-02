{
  lib,
  aiohttp,
  aioresponses,
  awesomeversion,
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
  pname = "aiomealie";
  version = "0.9.5";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-mealie";
    tag = "v${version}";
    hash = "sha256-hcHXX95d9T/jJMqHkikWN8ZdM5MRxJxhH575U3KDXxY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
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

  pythonImportsCheck = [ "aiomealie" ];

  meta = with lib; {
    description = "Module to interact with Mealie";
    homepage = "https://github.com/joostlek/python-mealie";
    changelog = "https://github.com/joostlek/python-mealie/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
