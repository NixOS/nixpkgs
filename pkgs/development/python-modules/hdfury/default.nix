{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
}:

buildPythonPackage (finalAttrs: {
  pname = "hdfury";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glenndehaan";
    repo = "python-hdfury";
    tag = finalAttrs.version;
    hash = "sha256-prqaH868nC5b7+1TrVRDxCcAt4v1dyF3bQAnkQgjKx0=";
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
