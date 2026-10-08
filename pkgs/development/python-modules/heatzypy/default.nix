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
  version = "2.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Cyr-ius";
    repo = "heatzypy";
    tag = finalAttrs.version;
    hash = "sha256-7hoei8uFDmSeqKSBmhmVoF5lZNuDkNqSFT+YjKPnJlk=";
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
