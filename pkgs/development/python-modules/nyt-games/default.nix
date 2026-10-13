{
  aiohttp,
  aiointercept,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  orjson,
  hatchling,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "nyt-games";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-nyt-games";
    tag = "v${version}";
    hash = "sha256-u0Sc3q+9X47aM4mjNDO5ALqaL1vUujq8L6HFhv2snA4=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  pythonImportsCheck = [ "nyt_games" ];

  nativeCheckInputs = [
    aiointercept
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
