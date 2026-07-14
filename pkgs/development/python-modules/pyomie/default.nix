{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  deepdiff,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  rich,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyomie";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luuuis";
    repo = "pyomie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gsCPqKBzQ0nA47WT30PesGuJ4/jicYsFXl04KQ8H/KQ=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "click"
    "typer"
  ];

  dependencies = [
    aiohttp
    rich
    typer
  ];

  nativeCheckInputs = [
    aioresponses
    deepdiff
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyomie" ];

  meta = {
    description = "Client for OMIE - Spain and Portugal electricity market data";
    homepage = "https://github.com/luuuis/pyomie";
    changelog = "https://github.com/luuuis/pyomie/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
