{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyhomepilot";
  version = "0.0.3";

  __structuredAttrs = true;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nico0302";
    repo = "pyhomepilot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nscfONzo+numYygUBRO35rWM3/UoU8tYLKFpzlDH9QE=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyhomepilot" ];

  meta = {
    description = "Python module to communicate with the Rademacher HomePilot API";
    homepage = "https://github.com/nico0302/pyhomepilot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
