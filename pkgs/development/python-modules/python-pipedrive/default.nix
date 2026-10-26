{
  lib,
  buildPythonPackage,
  fetchPypi,
  httplib2,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-pipedrive";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-9JImnHOx3mukWakHuysIQOg7d9uGHMEl7/wugaiPGDk=";
  };

  propagatedBuildInputs = [ httplib2 ];

  doCheck = false; # Tests are not provided.

  meta = {
    description = "Python library for interacting with the pipedrive.com API";
    homepage = "https://github.com/jscott1989/python-pipedrive";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ mrmebelman ];
  };
})
