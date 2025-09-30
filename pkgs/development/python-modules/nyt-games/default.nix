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
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "joostlek";
    repo = "python-nyt-games";
    tag = "v${version}";
    hash = "sha256-bpamhrTBDFp1c/RvvbVjRFXEn5HoxY+3jGH7NkfsFxo=";
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
