{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  voluptuous,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "python-awair";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ahayworth";
    repo = "python_awair";
    tag = version;
    hash = "sha256-ZET24T6MeCPPL1V84538U6Fb/ZVGv1hwcdTQi3Q+yMY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    voluptuous
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
    vcrpy
  ];

  pythonImportsCheck = [ "python_awair" ];

  meta = {
    changelog = "https://github.com/ahayworth/python_awair/releases/tag/${src.tag}";
    description = "Python library for the Awair API";
    homepage = "https://github.com/ahayworth/python_awair";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
