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
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-mealie";
    tag = "v${version}";
    hash = "sha256-sz/8b0iTtvS4RPBJynvGKf5oiRPJ9Lu/z6leZ1Hoqns=";
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
    changelog = "https://github.com/joostlek/python-mealie/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
