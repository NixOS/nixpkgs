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
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luuuis";
    repo = "pyomie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BOaOClTXeoRxWb2aJKN6+lQRCLAShvHPXsUZBbH0mno=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "typer" ];

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
