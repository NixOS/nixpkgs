{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  path,
}:

buildPythonPackage (finalAttrs: {
  pname = "pickleshare";
  version = "0.7.5";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-h2g9R5ZcHaZc2srzHIRB0SuARM3smspQDNePwsaDr8o=";
  };

  build-system = [ setuptools ];

  dependencies = [ path ];

  # No proper test suite
  doCheck = false;

  meta = {
    description = "Tiny 'shelve'-like database with concurrency support";
    homepage = "https://github.com/ipython/pickleshare";
    license = lib.licenses.mit;
  };
})
