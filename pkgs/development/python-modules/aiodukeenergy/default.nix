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
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hunterjm";
    repo = "aiodukeenergy";
    rev = "refs/tags/v${version}";
    hash = "sha256-aDBleEp3ZlY1IfFCbsUEU+wzYgjNaJeip8crHlh5qHE=";
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
    changelog = "https://github.com/hunterjm/aiodukeenergy/blob/${src.rev}/CHANGELOG.md";
    description = "Asyncio Duke Energy";
    homepage = "https://github.com/hunterjm/aiodukeenergy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
