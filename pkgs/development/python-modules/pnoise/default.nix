{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,

  # dependencies
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "pnoise";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-djgzENYCvMftI1XNM0+OvFuI5x1b/f7jLRuT05gZcs8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
  ];

  meta = {
    changelog = "https://github.com/plottertools/pnoise/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Vectorized port of Processing noise() function";
    homepage = "https://github.com/plottertools/pnoise";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ kybe236 ];
  };
})
