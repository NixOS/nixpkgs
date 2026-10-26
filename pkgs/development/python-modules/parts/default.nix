{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "parts";
  version = "4.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-uw/bo+Y24KIgKH+hfc4iUboH8jJKeaoQGHBv6KjZixU=";
  };

  build-system = [ setuptools ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "parts" ];

  meta = {
    description = "Library for common list functions related to partitioning lists";
    homepage = "https://github.com/lapets/parts";
    changelog = "https://github.com/lapets/parts/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
