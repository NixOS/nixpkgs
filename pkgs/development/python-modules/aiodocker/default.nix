{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "aiodocker";
  version = "0.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiodocker";
    tag = "v${version}";
    hash = "sha256-SaPTMpMljAh/6Km/JrbEjAOm30gBHH2QBkj7At/BTBA=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    aiohttp
  ];

  # tests require docker daemon
  doCheck = false;

  pythonImportsCheck = [ "aiodocker" ];

  meta = {
    changelog = "https://github.com/aio-libs/aiodocker/releases/tag/${src.tag}";
    description = "Docker API client for asyncio";
    homepage = "https://github.com/aio-libs/aiodocker";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emilytrau ];
  };
}
