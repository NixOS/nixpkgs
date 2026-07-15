{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  click,
}:

buildPythonPackage rec {
  pname = "click-log";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OXD4VwrFRJEje82z2KtePu9sBX3yn4w9EVGlGpwjuXU=";
  };

  build-system = [ setuptools ];

  dependencies = [ click ];

  meta = {
    homepage = "https://github.com/click-contrib/click-log/";
    description = "Logging integration for Click";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
