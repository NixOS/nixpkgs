{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  asgiref,
  greenlet,
  importlib-metadata,
  outcome,
  setuptools,
  sniffio,
}:

buildPythonPackage (finalAttrs: {
  pname = "greenback";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oremanj";
    repo = "greenback";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YAQEG3Lnyy9O+d58zZatDOeF+rxk34VqJ09XikqTyQk=";
  };

  build-system = [
    importlib-metadata
    setuptools
  ];

  dependencies = [
    asgiref
    greenlet
    outcome
    sniffio
  ];

  pythonImportsCheck = [ "greenback" ];

  meta = {
    description = "Use anyio and asyncio from synchronous code";
    homepage = "https://github.com/oremanj/greenback";
    changelog = "https://github.com/oremanj/greenback/blob/${finalAttrs.src.tag}/docs/source/history.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taranarmo ];
  };
})
