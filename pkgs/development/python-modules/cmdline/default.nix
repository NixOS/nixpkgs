{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyyaml,
}:

buildPythonPackage (finalAttrs: {
  pname = "cmdline";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-fPavU1SYkrIhjC9WoZnf9UpzO+XFUVwP1iaBIHCwqGo=";
  };

  build-system = [ setuptools ];

  # No tests, https://github.com/rca/cmdline/issues/1
  doCheck = false;
  dependencies = [ pyyaml ];

  pythonImportsCheck = [ "cmdline" ];

  meta = {
    description = "Utilities for consistent command line tools";
    homepage = "https://github.com/rca/cmdline";
    license = lib.licenses.asl20;
  };
})
