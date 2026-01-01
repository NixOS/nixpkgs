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
<<<<<<< HEAD
  version = "0.25.0";
=======
  version = "0.24.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiodocker";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-SaPTMpMljAh/6Km/JrbEjAOm30gBHH2QBkj7At/BTBA=";
=======
    hash = "sha256-qCOAM4ZyJoLc91FjQpBO97Nyfo1ZOEi0nhXZ7nwLsHk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/aio-libs/aiodocker/releases/tag/${src.tag}";
    description = "Docker API client for asyncio";
    homepage = "https://github.com/aio-libs/aiodocker";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emilytrau ];
=======
  meta = with lib; {
    changelog = "https://github.com/aio-libs/aiodocker/releases/tag/${src.tag}";
    description = "Docker API client for asyncio";
    homepage = "https://github.com/aio-libs/aiodocker";
    license = licenses.asl20;
    maintainers = with maintainers; [ emilytrau ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
