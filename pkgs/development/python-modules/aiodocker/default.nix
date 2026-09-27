{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  aiohttp,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiodocker";
  version = "0.27.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiodocker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l7CATx+kqT9aG3c523ctK0ooJDaJHw1Hf8Ow7EqFkDs=";
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
    changelog = "https://github.com/aio-libs/aiodocker/releases/tag/${finalAttrs.src.tag}";
    description = "Docker API client for asyncio";
    homepage = "https://github.com/aio-libs/aiodocker";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emilytrau ];
  };
})
