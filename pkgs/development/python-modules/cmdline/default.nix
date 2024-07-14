{
  lib,
  buildPythonPackage,
  fetchPypi,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "cmdline";
  version = "0.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fPavU1SYkrIhjC9WoZnf9UpzO+XFUVwP1iaBIHCwqGo=";
  };

  # No tests, https://github.com/rca/cmdline/issues/1
  doCheck = false;
  propagatedBuildInputs = [ pyyaml ];

  meta = with lib; {
    description = "Utilities for consistent command line tools";
    homepage = "https://github.com/rca/cmdline";
    license = licenses.asl20;
  };
}
