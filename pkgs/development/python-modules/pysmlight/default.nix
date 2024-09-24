{
  aiohttp,
  aiohttp-sse-client2,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pysmlight";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "smlight-tech";
    repo = "pysmlight";
    rev = "refs/tags/v${version}";
    hash = "sha256-b1f17jOEDQFtwBJa2zhbI8j2rRoMNJy8/WsVWanf6BI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    aiohttp-sse-client2
    mashumaro
  ];

  pythonImportsCheck = [ "pysmlight" ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/smlight-tech/pysmlight/releases/tag/v${version}";
    description = "Library implementing API control of the SMLIGHT SLZB-06 LAN Coordinators";
    homepage = "https://github.com/smlight-tech/pysmlight";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
