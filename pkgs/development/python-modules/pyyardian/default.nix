{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyyardian";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aeon-matrix";
    repo = "pyyardian";
    tag = finalAttrs.version;
    hash = "sha256-CL+FbgJqWmxNTPp7methLFMgLXkH2S9hkS2mru55cEI=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pyyardian" ];

  meta = {
    description = "Module for interacting with the Yardian irrigation controller";
    homepage = "https://github.com/aeon-matrix/pyyardian";
    changelog = "https://github.com/aeon-matrix/pyyardian/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
