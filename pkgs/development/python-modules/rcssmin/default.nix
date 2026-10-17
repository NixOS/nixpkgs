{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "rcssmin";
  version = "1.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/xWjiQ6zUPGqnsNJmPkUxOL7E/lJSW98JegHV4KBrc8=";
  };

  # The package does not ship tests, and the setup machinery confuses
  # tests auto-discovery
  doCheck = false;

  pythonImportsCheck = [ "rcssmin" ];

  meta = {
    description = "CSS minifier written in pure python";
    homepage = "http://opensource.perlig.de/rcssmin/";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
