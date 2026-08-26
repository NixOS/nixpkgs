{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "loqedapi";
  version = "2.1.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cpolhout";
    repo = "loqedAPI";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DLnjIq0YQIspPWYP9KT0UZ9UPGg5SOjYuVM7XqCUqTo=";
  };

  build-system = [ setuptools ];

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
