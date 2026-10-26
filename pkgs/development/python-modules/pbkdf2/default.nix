{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage (finalAttrs: {
  pname = "pbkdf2";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-rGOXNp8SghLEMGSitIeAONq3jatBh1NkVUqvKmhOaXk=";
  };

  # ImportError: No module named test
  doCheck = false;

  meta = {
    maintainers = [ ];
    license = lib.licenses.mit;
  };
})
