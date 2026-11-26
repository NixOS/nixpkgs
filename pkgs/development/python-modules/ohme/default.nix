{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ohme";
  version = "1.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dan-r";
    repo = "ohmepy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uLEsE/Toe69Ncv9cl++oW62wxkN/ZHiDzJ5YyMX5ImQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "ohme" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Module for interacting with the Ohme API";
    homepage = "https://github.com/dan-r/ohmepy";
    changelog = "https://github.com/dan-r/ohmepy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
