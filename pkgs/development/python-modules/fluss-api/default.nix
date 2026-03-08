{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fluss-api";
  version = "0.1.9.20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fluss";
    repo = "Fluss_Python_Library";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g5LZWlz8QZWUb6UFyY1wQIHqC2lCTpCsaWgrkPCoDOw=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "fluss_api" ];

  meta = {
    description = "Fluss+ API Client";
    homepage = "https://github.com/fluss/Fluss_Python_Library";
    changelog = "https://github.com/fluss/Fluss_Python_Library/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
