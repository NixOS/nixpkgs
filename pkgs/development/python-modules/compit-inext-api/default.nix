{
  aiofiles,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "compit-inext-api";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Przemko92";
    repo = "compit-inext-api";
    tag = finalAttrs.version;
    hash = "sha256-Me3bVTz9kZcuPgFM3/SZlcvw8LgqxQnXuLfY5lLhUeU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
  ];

  pythonImportsCheck = [ "compit_inext_api" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Python client for the Compit iNext API";
    homepage = "https://github.com/Przemko92/compit-inext-api";
    changelog = "https://github.com/Przemko92/compit-inext-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
