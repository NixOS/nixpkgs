{
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  yarl,
}:

buildPythonPackage rec {
  pname = "aiodukeenergy";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hunterjm";
    repo = "aiodukeenergy";
    tag = "v${version}";
    hash = "sha256-BYDC2j2s6gg8/owTDdijqmReUSqDYWqHXf8BUzYn+sI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    yarl
  ];

  pythonImportsCheck = [ "aiodukeenergy" ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/hunterjm/aiodukeenergy/blob/${src.tag}/CHANGELOG.md";
    description = "Asyncio Duke Energy";
    homepage = "https://github.com/hunterjm/aiodukeenergy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
