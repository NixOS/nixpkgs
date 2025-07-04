{
  aiohttp,
  aiomqtt,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "letpot";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jpelgrom";
    repo = "python-letpot";
    tag = "v${version}";
    hash = "sha256-ScguCgShoZ+qSfw558kqodpcpyPGy9HU6c2qAVOQb+c=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiomqtt
  ];

  pythonImportsCheck = [ "letpot" ];

  nativeCheckInputs = [
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
