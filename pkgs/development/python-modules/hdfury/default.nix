{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "hdfury";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glenndehaan";
    repo = "python-hdfury";
    tag = finalAttrs.version;
    hash = "sha256-UVJgmCwsvtx/Zq2qqTI8E1DmC4ayoWWI7duaommUQ2I=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "hdfury" ];

  # Module no tests
  doCheck = false;

  meta = {
    description = "Python client for HDFury devices";
    homepage = "https://github.com/glenndehaan/python-hdfury";
    changelog = "https://github.com/glenndehaan/python-hdfury/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
