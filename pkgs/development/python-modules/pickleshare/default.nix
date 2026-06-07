{
  lib,
  buildPythonPackage,
  fetchPypi,
  path,
}:

buildPythonPackage (finalAttrs: {
  version = "0.7.5";
  format = "setuptools";
  pname = "pickleshare";

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca";
  };

  propagatedBuildInputs = [ path ];

  # No proper test suite
  doCheck = false;

  meta = {
    description = "Tiny 'shelve'-like database with concurrency support";
    homepage = "https://github.com/vivainio/pickleshare";
    license = lib.licenses.mit;
  };
})
