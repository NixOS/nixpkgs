{
  aiohttp,
  aiomqtt,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "letpot";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpelgrom";
    repo = "python-letpot";
    tag = "v${version}";
    hash = "sha256-ULU+KBeE7T7qFQvw4KXz3/o2ZkZZa/C1QGqTPwlK7+c=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiomqtt
  ];

  pythonImportsCheck = [ "letpot" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/jpelgrom/python-letpot/releases/tag/${src.tag}";
    description = "Asynchronous Python client for LetPot hydroponic gardens";
    homepage = "https://github.com/jpelgrom/python-letpot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
