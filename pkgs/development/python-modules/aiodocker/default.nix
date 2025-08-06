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
  version = "0.24.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiodocker";
    tag = "v${version}";
    hash = "sha256-qCOAM4ZyJoLc91FjQpBO97Nyfo1ZOEi0nhXZ7nwLsHk=";
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

  meta = with lib; {
    changelog = "https://github.com/aio-libs/aiodocker/releases/tag/${src.tag}";
    description = "Docker API client for asyncio";
    homepage = "https://github.com/aio-libs/aiodocker";
    license = licenses.asl20;
    maintainers = with maintainers; [ emilytrau ];
  };
}
