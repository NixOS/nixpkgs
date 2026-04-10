{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "indevolt-api";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Xirt";
    repo = "indevolt-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l5O4Wn3TBG0grAVUnUJPvdavSka+7YX5cpQp7PzxuAg=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # no tests in upstream repository
  doCheck = false;

  pythonImportsCheck = [ "indevolt_api" ];

  meta = {
    description = "Python API client for Indevolt devices";
    homepage = "https://github.com/Xirt/indevolt-api";
    changelog = "https://github.com/Xirt/indevolt-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
