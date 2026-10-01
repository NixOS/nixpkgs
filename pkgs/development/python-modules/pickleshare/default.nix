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
    sha256 = "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca";
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
