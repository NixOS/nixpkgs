{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "fluss-api";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fluss";
    repo = "Fluss_Python_Library";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LD+boeDNWOm3KXZFIkLPvzIyngmFd6lOtIFsrn478wA=";
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
