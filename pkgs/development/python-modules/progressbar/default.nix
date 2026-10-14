{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "progressbar";
  version = "2.5";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-XYHLUp2i4iO1OWKv1sjKDwXGZw5AMJpyGerMNq+bbGM=";
  };

  # invalid command 'test'
  doCheck = false;

  meta = {
    homepage = "https://pypi.org/project/progressbar/";
    description = "Text progressbar library for python";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
})
