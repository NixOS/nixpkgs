{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ohme";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dan-r";
    repo = "ohmepy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4Cz08MFtWJomWHQzTubD3s8kMfUt7aZwD7buwEN2yn8=";
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
