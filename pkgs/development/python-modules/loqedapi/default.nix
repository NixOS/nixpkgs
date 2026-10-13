{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "loqedapi";
  version = "2.1.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cpolhout";
    repo = "loqedAPI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9IYVFa2yQshDhc2vGJs3ZfF4Ju6wlkif0UivWFl8jCw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "loqedAPI" ];

  meta = {
    description = "Module to interact with the Loqed Smart Door Lock API";
    homepage = "https://github.com/cpolhout/loqedAPI";
    changelog = "https://github.com/cpolhout/loqedAPI/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
  };
})
