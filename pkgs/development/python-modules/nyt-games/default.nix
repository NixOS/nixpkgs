{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "nyt-games";
  version = "0.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-nyt-games";
    tag = "v${version}";
    hash = "sha256-eMJ96E4sGmekr6mOR30UIZBclH/0xc8AWv3zL1ItKjo=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  pythonImportsCheck = [ "nyt_games" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/joostlek/python-nyt-games/releases/tag/${src.tag}";
    description = "Asynchronous Python client for NYT games";
    homepage = "https://github.com/joostlek/python-nyt-games";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
