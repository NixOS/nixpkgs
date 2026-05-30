{
  lib,
  buildPythonPackage,
  fetchPypi,
  click,
}:

buildPythonPackage rec {
  pname = "click-log";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OXD4VwrFRJEje82z2KtePu9sBX3yn4w9EVGlGpwjuXU=";
  };

  propagatedBuildInputs = [ click ];

  meta = {
    homepage = "https://github.com/click-contrib/click-log/";
    description = "Logging integration for Click";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
