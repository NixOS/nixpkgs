{
  buildPythonPackage,
  fetchPypi,
  lib,
}:

buildPythonPackage rec {
  pname = "parsley";
  version = "1.3";
  format = "setuptools";
  src = fetchPypi {
    pname = "Parsley";
    inherit version;
    hash = "sha256-lEQnjUcWHV8r52p2eAmjy+bbTbgi9GpP10gdQFcgjUE=";
  };
  # Tests fail although the package works just fine.  Unfortunately
  # the tests as run by the upstream CI server travis.org are broken.
  doCheck = false;
  meta = {
    license = lib.licenses.mit;
    homepage = "https://launchpad.net/parsley";
    description = "Parser generator library based on OMeta, and other useful parsing tools";
    maintainers = with lib.maintainers; [ seppeljordan ];
  };
}
