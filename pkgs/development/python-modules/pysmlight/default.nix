{
  aiohttp,
  aiohttp-sse-client2,
  aresponses,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
  mashumaro,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysmlight";
  version = "0.2.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "smlight-tech";
    repo = "pysmlight";
    tag = "v${version}";
    hash = "sha256-+ApqlqrNGQJ52VJPaaWCddsQGMu7W2fLJLKxV69zJKI=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    aiohttp
    aiohttp-sse-client2
    awesomeversion
    mashumaro
  ];

  pythonImportsCheck = [ "pysmlight" ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/smlight-tech/pysmlight/releases/tag/${src.tag}";
    description = "Library implementing API control of the SMLIGHT SLZB-06 LAN Coordinators";
    homepage = "https://github.com/smlight-tech/pysmlight";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
