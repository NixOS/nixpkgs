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
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "h3l1o5";
    repo = "pyyardian";
    tag = finalAttrs.version;
    hash = "sha256-xikLOZjoa8XQ9v8odJRJpqM94zAjMPpSVH9uJSFvk68=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "pyyardian" ];

  meta = {
    description = "Module for interacting with the Yardian irrigation controller";
    homepage = "https://github.com/h3l1o5/pyyardian";
    changelog = "https://github.com/aeon-matrix/pyyardian/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
