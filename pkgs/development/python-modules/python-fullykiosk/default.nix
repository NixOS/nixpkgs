{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-fullykiosk";
  version = "0.0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgarwood";
    repo = "python-fullykiosk";
    tag = finalAttrs.version;
    hash = "sha256-7agAI+Kp7ApMQ7qYgVPa32yjkkrbgZNWNkNEpyR0ALw=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "fullykiosk" ];

  meta = {
    description = "Wrapper for Fully Kiosk Browser REST interface";
    homepage = "https://github.com/cgarwood/python-fullykiosk";
    changelog = "https://github.com/cgarwood/python-fullykiosk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
