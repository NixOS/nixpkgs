{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  xmltodict,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioeagle";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioeagle";
    tag = finalAttrs.version;
    hash = "sha256-MJTq8mWdn+QvLhagPwmdXVcGnDB8Y+2ivBFV6h9vnDU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    xmltodict
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "aioeagle" ];

  meta = {
    description = "Python library to control EAGLE-200";
    homepage = "https://github.com/home-assistant-libs/aioeagle";
    changelog = "https://github.com/home-assistant-libs/aioshelly/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
