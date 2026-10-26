{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "faadelays";
  version = "2023.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ngMFd+BE3hKeaeGEX4xHpzDIrtGFDsSwxBbrc4ZMFas=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "faadelays" ];

  meta = {
    changelog = "https://github.com/ntilley905/faadelays/releases/tag/v${finalAttrs.version}";
    description = "Python package to retrieve FAA airport status";
    homepage = "https://github.com/ntilley905/faadelays";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
