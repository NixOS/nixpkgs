{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "heatzypy";
  version = "2.5.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Cyr-ius";
    repo = "heatzypy";
    tag = finalAttrs.version;
    hash = "sha256-6vdzxQGNQSMCFYA/nQ2T72RUWmBRvb9v0YcxVbjtG94=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "heatzypy" ];

  meta = {
    description = "Module to interact with Heatzy devices";
    homepage = "https://github.com/Cyr-ius/heatzypy";
    changelog = "https://github.com/cyr-ius/heatzypy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
